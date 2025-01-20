import Testing
@testable import AdventOfCode

@Suite struct Day22Tests {
    @Test func testDay22_1a() throws {
        let day = Day22(input: """
        deal with increment 7
        deal into new stack
        deal into new stack
        """, deckSize: 10)
        #expect(day.part1() == 0)
        #expect(day.deck == [0,3,6,9,2,5,8,1,4,7])
    }

    @Test func testDay22_1b() throws {
        let day = Day22(input: """
        cut 6
        deal with increment 7
        deal into new stack
        """, deckSize: 10)
        #expect(day.part1() == 0)
        #expect(day.deck == [3, 0, 7, 4, 1, 8, 5, 2, 9, 6])
    }

    @Test func testDay22_1c() throws {
        let day = Day22(input: """
        deal with increment 7
        deal with increment 9
        cut -2
        """, deckSize: 10)
        #expect(day.part1() == 0)
        #expect(day.deck == [6, 3, 0, 7, 4, 1, 8, 5, 2, 9])
    }

    @Test func testDay22_1d() throws {
        let day = Day22(input: """
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
}
