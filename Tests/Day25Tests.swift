import Testing
@testable import AdventOfCode

@Suite struct Day25Tests {

    @Test func testDay25_part1_solution() throws {
        let day = Day25(input: Day25.input)
        #expect(day.part1() == 10504192)
    }

}
