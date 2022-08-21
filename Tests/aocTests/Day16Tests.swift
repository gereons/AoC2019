import XCTest
@testable import AdventOfCode

final class Day16Tests: XCTestCase {
//    func testDay16_0() throws {
//        XCTAssertEqual(Day16(rawInput: "12345678").part1(), "00000000")
//    }

    func testDay16_1() throws {
        XCTAssertEqual(Day16(rawInput: "80871224585914546619083218645595").part1(), "24176176")
        XCTAssertEqual(Day16(rawInput: "19617804207202209144916044189917").part1(), "73745418")
        XCTAssertEqual(Day16(rawInput: "69317163492948606335995924319873").part1(), "52432133")
    }

    func testDay16_2() throws {
        XCTAssertEqual(Day16(rawInput: "03036732577212944063491565474664").part2(), "84462026")
        XCTAssertEqual(Day16(rawInput: "02935109699940807407585447034323").part2(), "78725270")
        XCTAssertEqual(Day16(rawInput: "03081770884921959731165446850517").part2(), "53553731")
    }
}
