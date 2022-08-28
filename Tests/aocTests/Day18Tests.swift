import XCTest
@testable import AdventOfCode

final class Day18Tests: XCTestCase {
    func testDay18_1a() throws {
        let input = """
        #########
        #b.A.@.a#
        #########
        """
        let day = Day18(rawInput: input)
        XCTAssertEqual(day.part1(), 8)
    }

    func testDay18_1b() throws {
        let input = """
        ########################
        #f.D.E.e.C.b.A.@.a.B.c.#
        ######################.#
        #d.....................#
        ########################
        """
        let day = Day18(rawInput: input)
        XCTAssertEqual(day.part1(), 86)
    }

    func testDay18_1c() throws {
        let input = """
        ########################
        #...............b.C.D.f#
        #.######################
        #.....@.a.B.c.d.A.e.F.g#
        ########################
        """
        let day = Day18(rawInput: input)
        XCTAssertEqual(day.part1(), 132)
    }

    func testDay18_1d() throws {
        let input = """
        #################
        #i.G..c...e..H.p#
        ########.########
        #j.A..b...f..D.o#
        ########@########
        #k.E..a...g..B.n#
        ########.########
        #l.F..d...h..C.m#
        #################
        """
        let day = Day18(rawInput: input)
        XCTAssertEqual(day.part1(), 136)
    }

    func testDay18_1e() throws {
        let input = """
        ########################
        #@..............ac.GI.b#
        ###d#e#f################
        ###A#B#C################
        ###g#h#i################
        ########################
        """
        let day = Day18(rawInput: input)
        XCTAssertEqual(day.part1(), 81)
    }

    func testDay18_2() throws {
        let day = Day18(rawInput: "bar")
        XCTAssertEqual(day.part2(), 0)
    }
}
