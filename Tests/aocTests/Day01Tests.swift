import XCTest
@testable import AdventOfCode

final class Day01Tests: XCTestCase {
    func testDay01_1() throws {
        XCTAssertEqual(Day01(rawInput: "12").part1(), 2)
        XCTAssertEqual(Day01(rawInput: "14").part1(), 2)
        XCTAssertEqual(Day01(rawInput: "1969").part1(), 654)
        XCTAssertEqual(Day01(rawInput: "100756").part1(), 33583)
    }

    func testDay01_2() throws {
        XCTAssertEqual(Day01(rawInput: "14").part2(), 2)
        XCTAssertEqual(Day01(rawInput: "1969").part2(), 966)
        XCTAssertEqual(Day01(rawInput: "100756").part2(), 50346)
    }
}
