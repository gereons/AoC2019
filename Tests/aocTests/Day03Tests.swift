import XCTest
@testable import AdventOfCode

final class Day03Tests: XCTestCase {
    func testDay03_1() throws {
        var day = Day03(rawInput: "R8,U5,L5,D3\nU7,R6,D4,L4")
        XCTAssertEqual(day.part1(), 6)

        day = Day03(rawInput: "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83")
        XCTAssertEqual(day.part1(), 159)

        day = Day03(rawInput: "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
        XCTAssertEqual(day.part1(), 135)
    }

    func testDay03_2() throws {
        var day = Day03(rawInput: "R8,U5,L5,D3\nU7,R6,D4,L4")
        XCTAssertEqual(day.part2(), 30)

        day = Day03(rawInput: "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83")
        XCTAssertEqual(day.part2(), 610)

        day = Day03(rawInput: "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
        XCTAssertEqual(day.part2(), 410)
    }
}
