import Testing
@testable import AdventOfCode

@Suite struct Day18Tests {
    @Test func testDay18_part1() throws {
        let input = """
        #########
        #b.A.@.a#
        #########
        """
        var day = Day18(input: input)
        #expect(day.part1() == 8)

        let input2 = """
        ########################
        #f.D.E.e.C.b.A.@.a.B.c.#
        ######################.#
        #d.....................#
        ########################
        """
        day = Day18(input: input2)
        #expect(day.part1() == 86)

        let input3 = """
        ########################
        #...............b.C.D.f#
        #.######################
        #.....@.a.B.c.d.A.e.F.g#
        ########################
        """
        day = Day18(input: input3)
        #expect(day.part1() == 132)

        let input4 = """
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
        day = Day18(input: input4)
        #expect(day.part1() == 136)

        let input5 = """
        ########################
        #@..............ac.GI.b#
        ###d#e#f################
        ###A#B#C################
        ###g#h#i################
        ########################
        """
        day = Day18(input: input5)
        #expect(day.part1() == 81)
    }

    @Test func testDay18_part2() throws {
        let input = """
        #######
        #a.#Cd#
        ##@#@##
        #######
        ##@#@##
        #cB#.b#
        #######
        """
        var day = Day18(input: input)
        #expect(day.part2() == 8)

        let input2 = """
        ###############
        #d.ABC.#.....a#
        ######@#@######
        ###############
        ######@#@######
        #b.....#.....c#
        ###############
        """
        day = Day18(input: input2)
        #expect(day.part2() == 24)

        let input3 = """
        #############
        #DcBa.#.GhKl#
        #.###@#@#I###
        #e#d#####j#k#
        ###C#@#@###J#
        #fEbA.#.FgHi#
        #############
        """
        day = Day18(input: input3)
        #expect(day.part2() == 32)

        let input4 = """
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
        day = Day18(input: input4)
        #expect(day.part2() == 72)
    }

    @Test func testDay18_part1_solution() throws {
        let day = Day18(input: Day18.input)
        #expect(day.part1() == 5198)
    }

    @Test func testDay18_part2_solution() throws {
        let day = Day18(input: Day18.input)
        #expect(day.part2() == 1736)
    }
}
