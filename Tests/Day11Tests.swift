//
//  Day08Tests.swift
//  AdventOfCode
//
//  Created by Gereon Steffens on 11.01.25.
//

import Testing
@testable import AdventOfCode

@Suite struct Day11Tests {
    @Test func testDay11_part1_solution() throws {
        let day = Day11(input: Day11.input)
        #expect(day.part1() == 2511)
    }

    @Test func testDay11_part2_solution() throws {
        let day = Day11(input: Day11.input)
        #expect(day.part2() == "HJKJKGPH")
    }

}
