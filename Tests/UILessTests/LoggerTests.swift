import Foundation
import Testing
@testable import UILess

@Test func loggerRoutesRecordsToMemoryDestination() async throws {
    let memory = MemoryLogDestination()
    let logger = Logger(
        minimumLevel: .trace,
        routes: [
            LogRoute(destination: memory),
        ]
    )

    await logger.info("ready", category: "startup")

    let records = await memory.records
    #expect(records.count == 1)
    #expect(records.first?.message == "ready")
    #expect(records.first?.level == .info)
    #expect(records.first?.category == "startup")
}

@Test func loggerFiltersByMinimumLevel() async throws {
    let memory = MemoryLogDestination()
    let logger = Logger(
        minimumLevel: .warning,
        routes: [
            LogRoute(destination: memory),
        ]
    )

    await logger.info("ignored")
    await logger.error("kept")

    let records = await memory.records
    #expect(records.map(\.message) == ["kept"])
}

@Test func logRoutesCanFilterByCategory() async throws {
    let startup = MemoryLogDestination()
    let runtime = MemoryLogDestination()
    let logger = Logger(
        minimumLevel: .trace,
        routes: [
            LogRoute(acceptedCategories: ["startup"], destination: startup),
            LogRoute(acceptedCategories: ["runtime"], destination: runtime),
        ]
    )

    await logger.info("boot", category: "startup")
    await logger.info("tick", category: "runtime")
    await logger.info("hidden", category: "other")

    #expect(await startup.records.map(\.message) == ["boot"])
    #expect(await runtime.records.map(\.message) == ["tick"])
}

@Test func memoryDestinationKeepsMostRecentRecords() async throws {
    let memory = MemoryLogDestination(maximumRecordCount: 2)
    let logger = Logger(
        minimumLevel: .trace,
        routes: [
            LogRoute(destination: memory),
        ]
    )

    await logger.info("one")
    await logger.info("two")
    await logger.info("three")

    #expect(await memory.records.map(\.message) == ["two", "three"])
}

@Test func loggerTruncatesLongMessages() async throws {
    let memory = MemoryLogDestination()
    let logger = Logger(
        minimumLevel: .trace,
        messageMaximumLength: 4,
        routes: [
            LogRoute(destination: memory),
        ]
    )

    await logger.info("abcdef")

    #expect(await memory.records.first?.message == "abcd...")
}
