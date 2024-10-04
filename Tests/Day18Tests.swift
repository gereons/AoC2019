import XCTest
@testable import AdventOfCode

@MainActor
final class Day18Tests: XCTestCase {
    func testDay18_1a() throws {
        let input = """
        #########
        #b.A.@.a#
        #########
        """
        let day = Day18(input: input)
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
        let day = Day18(input: input)
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
        let day = Day18(input: input)
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
        let day = Day18(input: input)
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
        let day = Day18(input: input)
        XCTAssertEqual(day.part1(), 81)
    }

    func testDay18_2a() throws {
        let input = """
        #######
        #a.#Cd#
        ##@#@##
        #######
        ##@#@##
        #cB#.b#
        #######
        """
        let day = Day18(input: input)
        XCTAssertEqual(day.part2(), 8)
    }

    func testDay18_2b() throws {
        let input = """
        ###############
        #d.ABC.#.....a#
        ######@#@######
        ###############
        ######@#@######
        #b.....#.....c#
        ###############
        """
        let day = Day18(input: input)
        XCTAssertEqual(day.part2(), 24)
    }

    func testDay18_2c() throws {
        let input = """
        #############
        #DcBa.#.GhKl#
        #.###@#@#I###
        #e#d#####j#k#
        ###C#@#@###J#
        #fEbA.#.FgHi#
        #############
        """
        let day = Day18(input: input)
        XCTAssertEqual(day.part2(), 32)
    }

    func testDay18_2d() throws {
        let input = """
        #############
        #g#f.D#..h#l#
        #F###e#E###.#
        #dCba@#@BcIJ#
        #############
        #nK.L@#@G...#
        #M###N#H###.#
        #o#m..#i#jk.#
        #############
        """
        let day = Day18(input: input)
        XCTAssertEqual(day.part2(), 72)
    }
}
