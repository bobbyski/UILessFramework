import Foundation

public actor Logger {
    public static let shared = Logger()

    public private(set) var routes: [LogRoute]
    public var minimumLevel: LogLevel
    public var messageMaximumLength: Int
    public var defaultSubsystem: String?

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

    public func addRoute(_ route: LogRoute) {
        routes.append(route)
    }

    public func removeAllRoutes() {
        routes.removeAll()
    }

    public func replaceRoutes(with routes: [LogRoute]) {
        self.routes = routes
    }

    public func setMinimumLevel(_ level: LogLevel) {
        minimumLevel = level
    }

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

        for route in routes where route.accepts(record) {
            await route.destination.write(record)
        }
    }

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
    func uIlessReadableString() -> String {
        if let string = uIlessDisplayableString() {
            return string
        }

        return uIlessHexDump()
    }

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
            let paddedHexBytes = hexBytes.padding(toLength: 96, withPad: " ", startingAt: 0)

            lines.append("\(paddedHexBytes) | \(asciiBytes)")
        }

        return lines.joined(separator: "\n")
    }
}
