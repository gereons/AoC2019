import Testing
@testable import AdventOfCode

@Suite struct Day17Tests {
    @Test func testDay17_part1_solution() throws {
        let day = Day17(input: Day17.input)
        #expect(day.part1() == 4112)
    }

    @Test func testDay17_part2_solution() throws {
        let day = Day17(input: Day17.input)
        #expect(day.part2() == 578918)
    }

}
