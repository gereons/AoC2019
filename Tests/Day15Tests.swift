import Testing
@testable import AdventOfCode

@Suite struct Day15Tests {
    @Test func testDay15_part1_solution() throws {
        let day = Day15(input: Day15.input)
        #expect(day.part1() == 234)
    }

    @Test func testDay15_part2_solution() throws {
        let day = Day15(input: Day15.input)
        #expect(day.part2() == 292)
    }

}
