import Testing
@testable import AdventOfCode

@Suite struct Day06Tests {
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

    @Test func testDay06_part1() throws {
        let day = Day06(input: orbits1)
        #expect(day.part1() == 42)
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

    @Test func testDay06_part2() throws {
        let day = Day06(input: orbits2)
        #expect(day.part2() == 4)
    }

    @Test func testDay06_part1_solution() throws {
        #expect(Day06(input: Day06.input).part1() == 315757)
    }

    @Test func testDay06_part2_solution() throws {
        #expect(Day06(input: Day06.input).part2() == 481)
    }
}
