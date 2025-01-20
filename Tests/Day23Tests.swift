import Testing
@testable import AdventOfCode

@Suite struct Day23Tests {

    @Test func testDay23_part1_solution() throws {
        let day = Day23(input: Day23.input)
        #expect(day.part1() == 24954)
    }

    @Test func testDay23_part2_solution() throws {
        let day = Day23(input: Day23.input)
        #expect(day.part2() == 17091)
    }
}
