import Foundation

/// Actor-based structured logger with routeable destinations.
///
/// `Logger` serializes access to its routes and configuration while allowing
/// destinations to perform asynchronous work. Use `Logger.shared` for default
/// framework logging, or create isolated instances in tests and platform
/// adapters.
public actor Logger {
    /// Shared process-wide logger.
    public static let shared = Logger()

    /// Routes that receive accepted records.
    public private(set) var routes: [LogRoute]

    /// Global minimum level for this logger.
    public var minimumLevel: LogLevel

    /// Maximum number of characters retained per message before truncation.
    public var messageMaximumLength: Int

    /// Default subsystem attached to records when none is supplied.
    public var defaultSubsystem: String?

    /// Creates a logger.
    public init(
        minimumLevel: LogLevel = .info,
        messageMaximumLength: Int = 12 * 1024,
        defaultSubsystem: String? = nil,
        routes: [LogRoute] = [LogRoute(destination: ConsoleLogDestination())]
    ) {
        self.minimumLevel = minimumLevel
        self.messageMaximumLength = messageMaximumLength
        self.defaultSubsystem = defaultSubsystem
        self.routes = routes
    }

    /// Adds a destination route.
    public func addRoute(_ route: LogRoute) {
        routes.append(route)
    }

    /// Removes all destination routes.
    public func removeAllRoutes() {
        routes.removeAll()
    }

    /// Replaces all destination routes.
    public func replaceRoutes(with routes: [LogRoute]) {
        self.routes = routes
    }

    /// Updates the global minimum log level.
    public func setMinimumLevel(_ level: LogLevel) {
        minimumLevel = level
    }

    /// Emits a log message.
    public func log(
        _ message: String,
        level: LogLevel = .info,
        subsystem: String? = nil,
        category: String? = nil,
        metadata: [String: String] = [:],
        fileID: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) async {
        guard minimumLevel != .off, level.isLoggable, level >= minimumLevel else {
            return
        }

        let record = LogRecord(
            level: level,
            subsystem: subsystem ?? defaultSubsystem,
            category: category,
            message: limitedMessage(message),
            metadata: metadata,
            source: LogSource(fileID: fileID, function: function, line: line)
        )

        // Routes are evaluated inside the actor so route configuration cannot
        // change while a record is being fanned out.
        for route in routes where route.accepts(record) {
            await route.destination.write(record)
        }
    }

    /// Emits a trace message.
    public func trace(
        _ message: String,
        category: String? = nil,
        metadata: [String: String] = [:],
        fileID: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) async {
        await log(message, level: .trace, category: category, metadata: metadata, fileID: fileID, function: function, line: line)
    }

    /// Emits a debug message.
    public func debug(
        _ message: String,
        category: String? = nil,
        metadata: [String: String] = [:],
        fileID: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) async {
        await log(message, level: .debug, category: category, metadata: metadata, fileID: fileID, function: function, line: line)
    }

    /// Emits an informational message.
    public func info(
        _ message: String,
        category: String? = nil,
        metadata: [String: String] = [:],
        fileID: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) async {
        await log(message, level: .info, category: category, metadata: metadata, fileID: fileID, function: function, line: line)
    }

    /// Emits a warning message.
    public func warning(
        _ message: String,
        category: String? = nil,
        metadata: [String: String] = [:],
        fileID: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) async {
        await log(message, level: .warning, category: category, metadata: metadata, fileID: fileID, function: function, line: line)
    }

    /// Emits an error message.
    public func error(
        _ message: String,
        category: String? = nil,
        metadata: [String: String] = [:],
        fileID: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) async {
        await log(message, level: .error, category: category, metadata: metadata, fileID: fileID, function: function, line: line)
    }

    /// Emits an error by stringifying an `Error`.
    public func error(
        _ error: any Error,
        category: String? = nil,
        metadata: [String: String] = [:],
        fileID: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) async {
        await log(String(describing: error), level: .error, category: category, metadata: metadata, fileID: fileID, function: function, line: line)
    }

    /// Emits a command and, optionally, its result.
    public func command(
        _ command: String,
        result: String? = nil,
        category: String? = nil,
        metadata: [String: String] = [:],
        fileID: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) async {
        await log(command, level: .command, category: category, metadata: metadata, fileID: fileID, function: function, line: line)

        if let result {
            await log(result, level: .result, category: category, metadata: metadata, fileID: fileID, function: function, line: line)
        }
    }

    /// Emits data as UTF-8 text when possible, otherwise as a hex dump.
    public func data(
        _ data: Data,
        message: String? = nil,
        category: String? = nil,
        metadata: [String: String] = [:],
        fileID: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) async {
        var message = message.map { "\($0)\n" } ?? ""
        message += data.uIlessReadableString()

        await log(message, level: .data, category: category, metadata: metadata, fileID: fileID, function: function, line: line)
    }

    private func limitedMessage(_ message: String) -> String {
        guard message.count > messageMaximumLength else {
            return message
        }

        return String(message.prefix(messageMaximumLength)) + "..."
    }
}

private extension Data {
    /// Returns readable text for displayable UTF-8 data, falling back to a hex dump.
    func uIlessReadableString() -> String {
        if let string = uIlessDisplayableString() {
            return string
        }

        return uIlessHexDump()
    }

    /// Returns a string only when the data is valid, displayable ASCII text.
    func uIlessDisplayableString() -> String? {
        guard let string = String(data: self, encoding: .utf8) else {
            return nil
        }

        guard string.allSatisfy({ character in
            character.isASCII
                && (character.isLetter
                    || character.isNumber
                    || character.isWhitespace
                    || character.isPunctuation
                    || character.isSymbol)
        }) else {
            return nil
        }

        return string
    }

    /// Creates a fixed-width hex dump with an ASCII preview column.
    func uIlessHexDump(bytesPerLine: Int = 32) -> String {
        var lines: [String] = []

        for offset in stride(from: 0, to: count, by: bytesPerLine) {
            let chunk = dropFirst(offset).prefix(bytesPerLine)
            let hexBytes = chunk.map { String(format: "%02X", $0) }.joined(separator: " ")
            let asciiBytes = chunk.map { byte -> String in
                if byte >= 32, byte <= 126 {
                    return String(Unicode.Scalar(byte))
                }

                return "."
            }.joined()
            // Keep the ASCII column aligned so binary log output is scannable.
            let paddedHexBytes = hexBytes.padding(toLength: 96, withPad: " ", startingAt: 0)

            lines.append("\(paddedHexBytes) | \(asciiBytes)")
        }

        return lines.joined(separator: "\n")
    }
}
