import XCTest
@testable import AdventOfCode

@MainActor
final class Day01Tests: XCTestCase {
    func testDay01_1() throws {
        XCTAssertEqual(Day01(input: "12").part1(), 2)
        XCTAssertEqual(Day01(input: "14").part1(), 2)
        XCTAssertEqual(Day01(input: "1969").part1(), 654)
        XCTAssertEqual(Day01(input: "100756").part1(), 33583)
    }

    func testDay01_2() throws {
        XCTAssertEqual(Day01(input: "14").part2(), 2)
        XCTAssertEqual(Day01(input: "1969").part2(), 966)
        XCTAssertEqual(Day01(input: "100756").part2(), 50346)
    }
}
