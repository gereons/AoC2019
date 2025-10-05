import Testing
@testable import AdventOfCode

@Suite struct Day22Tests {
    @Test func testDay22_part1() throws {
        var day = Day22(input: """
        deal with increment 7
        deal into new stack
        deal into new stack
        """, deckSize: 10)
        #expect(day.part1() == 0)
        #expect(day.deck == [0, 3, 6, 9, 2, 5, 8, 1, 4, 7])

        day = Day22(input: """
        cut 6
        deal with increment 7
        deal into new stack
        """, deckSize: 10)
        #expect(day.part1() == 0)
        #expect(day.deck == [3, 0, 7, 4, 1, 8, 5, 2, 9, 6])

        day = Day22(input: """
        deal with increment 7
        deal with increment 9
        cut -2
        """, deckSize: 10)
        #expect(day.part1() == 0)
        #expect(day.deck == [6, 3, 0, 7, 4, 1, 8, 5, 2, 9])

        day = Day22(input: """
        deal into new stack
        cut -2
        deal with increment 7
        cut 8
        cut -4
        deal with increment 7
        cut 3
        deal with increment 9
        deal with increment 3
        cut -1
        """, deckSize: 10)
        #expect(day.part1() == 0)
        #expect(day.deck == [9, 2, 5, 8, 1, 4, 7, 0, 3, 6])
    }

    @Test func testDay22_part1_solution() throws {
        let day = Day22(input: Day22.input)
        #expect(day.part1() == 7395)
    }

    @Test func testDay22_part2_solution() throws {
        let day = Day22(input: Day22.input)
        #expect(day.part2() == 32376123569821)
    }
}
