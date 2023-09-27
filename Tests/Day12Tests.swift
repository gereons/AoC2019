import XCTest
@testable import AdventOfCode

final class Day12Tests: XCTestCase {
    func testDay12_1() throws {
        let d1 = Day12(input: """
        <x=-1, y=0, z=2>
        <x=2, y=-10, z=-7>
        <x=4, y=-8, z=8>
        <x=3, y=5, z=-1>
        """)
        XCTAssertEqual(d1.part1(steps: 10), 179)

        let d2 = Day12(input: """
        <x=-8, y=-10, z=0>
        <x=5, y=5, z=10>
        <x=2, y=-7, z=3>
        <x=9, y=-8, z=-3>
        """)
        XCTAssertEqual(d2.part1(steps: 100), 1940)
    }

    func testDay12_2() throws {
        let d1 = Day12(input: """
        <x=-1, y=0, z=2>
        <x=2, y=-10, z=-7>
        <x=4, y=-8, z=8>
        <x=3, y=5, z=-1>
        """)
        XCTAssertEqual(d1.part2(), 2772)
    }

    func testDay12_2b() throws {
        let d2 = Day12(input: """
        <x=-8, y=-10, z=0>
        <x=5, y=5, z=10>
        <x=2, y=-7, z=3>
        <x=9, y=-8, z=-3>
        """)
        XCTAssertEqual(d2.part2(), 4686774924)
    }
}
