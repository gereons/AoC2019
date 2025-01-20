import Testing
@testable import AdventOfCode

@Suite struct Day19Tests {
    @Test func testDay19_part1_solution() throws {
        let day = Day19(input: Day19.input)
        #expect(day.part1() == 131)
    }

    @Test func testDay19_part2_solution() throws {
        let day = Day19(input: Day19.input)
        #expect(day.part2() == 15231022)
    }

}
