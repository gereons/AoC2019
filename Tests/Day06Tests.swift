import XCTest
@testable import AdventOfCode

final class Day06Tests: XCTestCase {
    let orbits1 = """
    COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L
    """

    func testDay06_1() throws {
        let day = Day06(input: orbits1)
        XCTAssertEqual(day.part1(), 42)
    }

    let orbits2 = """
    COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L
    K)YOU
    I)SAN
    """

    func testDay06_2() throws {
        let day = Day06(input: orbits2)
        XCTAssertEqual(day.part2(), 4)
    }
}
