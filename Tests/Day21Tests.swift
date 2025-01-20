import Testing
@testable import AdventOfCode

@Suite struct Day21Tests {

    @Test func testDay21_part1_solution() throws {
        let day = Day21(input: Day21.input)
        #expect(day.part1() == 19355227)
    }

    @Test func testDay21_part2_solution() throws {
        let day = Day21(input: Day21.input)
        #expect(day.part2() == 1143802926)
    }
}
