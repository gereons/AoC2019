//
//  Day08Tests.swift
//  AdventOfCode
//
//  Created by Gereon Steffens on 11.01.25.
//

import Testing
@testable import AdventOfCode

@Suite struct Day08Tests {
    @Test func testDay08_part1_solution() throws {
        let day = Day08(input: Day08.input)
        #expect(day.part1() == 2064)
    }

    @Test func testDay08_part2_solution() throws {
        let day = Day08(input: Day08.input)
        #expect(day.part2() == "KAUZA")
    }

}
