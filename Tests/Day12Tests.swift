import Testing
@testable import AdventOfCode

@Suite struct Day12Tests {
    @Test func testDay12_part1() throws {
        let d1 = Day12(input: """
        <x=-1, y=0, z=2>
        <x=2, y=-10, z=-7>
        <x=4, y=-8, z=8>
        <x=3, y=5, z=-1>
        """)
        #expect(d1.part1(steps: 10) == 179)

        let d2 = Day12(input: """
        <x=-8, y=-10, z=0>
        <x=5, y=5, z=10>
        <x=2, y=-7, z=3>
        <x=9, y=-8, z=-3>
        """)
        #expect(d2.part1(steps: 100) == 1940)
    }

    @Test func testDay12_part2() throws {
        let d1 = Day12(input: """
        <x=-1, y=0, z=2>
        <x=2, y=-10, z=-7>
        <x=4, y=-8, z=8>
        <x=3, y=5, z=-1>
        """)
        #expect(d1.part2() == 2772)

        let d2 = Day12(input: """
        <x=-8, y=-10, z=0>
        <x=5, y=5, z=10>
        <x=2, y=-7, z=3>
        <x=9, y=-8, z=-3>
        """)
        #expect(d2.part2() == 4686774924)
    }

    @Test func testDay12_part1_solution() throws {
        let day = Day12(input: Day12.input)
        #expect(day.part1() == 6423)
    }

    @Test func testDay12_part2_solution() throws {
        let day = Day12(input: Day12.input)
        #expect(day.part2() == 327636285682704)
    }

}
