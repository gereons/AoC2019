import Testing
@testable import AdventOfCode

@Suite struct Day04Tests {
    @Test func testDay04_part1() throws {
        let d4 = Day04(input: "1-2")
        #expect(d4.isValidPassword(111111) == true)
        #expect(d4.isValidPassword(223450) == false)
        #expect(d4.isValidPassword(223450) == false)
    }

    @Test func testDay04_part2() throws {
        let d4 = Day04(input: "1-2")
        #expect(d4.isValidPassword(111111, part2: true) == false)
        #expect(d4.isValidPassword(223450, part2: true) == false)
        #expect(d4.isValidPassword(223450, part2: true) == false)

        #expect(d4.isValidPassword(112233, part2: true) == true)
        #expect(d4.isValidPassword(123444, part2: true) == false)
        #expect(d4.isValidPassword(111122, part2: true) == true)

        #expect(d4.isValidPassword(112333, part2: true) == true)
        #expect(d4.isValidPassword(112344, part2: true) == true)
    }

    @Test func testDay04_part1_solution() throws {
        #expect(Day04(input: Day04.input).part1() == 466)
    }

    @Test func testDay04_part2_solution() throws {
        #expect(Day04(input: Day04.input).part2() == 292)
    }
}
