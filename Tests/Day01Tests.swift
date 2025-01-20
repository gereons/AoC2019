import Testing
@testable import AdventOfCode

@Suite struct Day01Tests {
    @Test func testDay01_part1() throws {
        #expect(Day01(input: "12").part1() == 2)
        #expect(Day01(input: "14").part1() == 2)
        #expect(Day01(input: "1969").part1() == 654)
        #expect(Day01(input: "100756").part1() == 33583)
    }

    @Test func testDay01_part2() throws {
        #expect(Day01(input: "14").part2() == 2)
        #expect(Day01(input: "1969").part2() == 966)
        #expect(Day01(input: "100756").part2() == 50346)
    }

    @Test func testDay01_part1_solution() throws {
        #expect(Day01(input: Day01.input).part1() == 3479429)
    }

    @Test func testDay01_part2_solution() throws {
        #expect(Day01(input: Day01.input).part2() == 5216273)
    }
}
