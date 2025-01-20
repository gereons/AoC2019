import Testing
@testable import AdventOfCode

@Suite struct Day13Tests {
    @Test func testDay13_part1_solution() throws {
        let day = Day13(input: Day13.input)
        #expect(day.part1() == 452)
    }

    @Test func testDay13_part2_solution() throws {
        let day = Day13(input: Day13.input)
        #expect(day.part2() == 21415)
    }

}
