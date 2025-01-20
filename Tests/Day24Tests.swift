import Testing
import AoCTools
@testable import AdventOfCode

@Suite struct Day24Tests {
    let day = Day24(input: """
            ....#
            #..#.
            #..##
            ..#..
            #....
            """)

    @Test func testDay24_part1() throws {
        #expect(day.part1() == 2129920)
    }

    @Test func testRecursiveNeighboursInSameLevel() throws {
        let points = [Point(1,1), Point(3,1), Point(1,3), Point(3,3) ]

        for p in points {
            let n = day.findNeighbors(for: p, level: 1)
            #expect(n.count == 4)
            #expect(n.allSatisfy { $0.z == 1 })
        }
    }

    @Test func testRecursiveNeighboursCorners() throws {
        let points = [Point(0,0), Point(4,0), Point(0,4), Point(4,4) ]

        for p in points {
            let n = day.findNeighbors(for: p, level: 1)
            #expect(n.count == 4)
            #expect(n.filter { $0.z == 1}.count == 2)
            #expect(n.filter { $0.z == 0}.count == 2)
        }
    }

    @Test func testRecursiveNeighboursEdgeOutside() throws {
        let points = [
            Point(1,0), Point(2,0), Point(3,0),
            Point(4,1), Point(4,2), Point(4,3),
            Point(1,4), Point(2,4), Point(3,4),
            Point(0,1), Point(0,2), Point(0,3)
        ]

        for p in points {
            let n = day.findNeighbors(for: p, level: 1)
            #expect(n.count == 4)
            #expect(n.filter { $0.z == 1}.count == 3)
            #expect(n.filter { $0.z == 0}.count == 1)
        }
    }

    @Test func testRecursiveNeighboursCenterInside() throws {
        let points = [ Point(2,1), Point(1,2), Point(3,2), Point(2,3) ]

        for p in points {
            let n = day.findNeighbors(for: p, level: 1)
            #expect(n.count == 8)
            #expect(n.filter { $0.z == 1}.count == 3)
            #expect(n.filter { $0.z == 2}.count == 5)
        }
    }

    @Test func testRecursiveNeighbors() throws {
        let day = Day24(input: """
            ....#
            #..#.
            #..##
            ..#..
            #....
            """, generations: 10)
        // tile 19
        let n33 = day.findNeighbors(for: Point(3, 3), level: 0)
        #expect(n33.count == 4)
        #expect(n33.allSatisfy { $0.z == 0 })

        // tile 7 / G
        let n11 = day.findNeighbors(for: Point(1, 1), level: 17)
        #expect(n11.count == 4)
        #expect(n11.allSatisfy { $0.z == 17 })

        // tile 4 / D
        let n30 = day.findNeighbors(for: Point(3, 0), level: 0)
        #expect(n30.count == 4)
        #expect(n30.filter { $0.z == 0 }.count == 3)
        #expect(n30.filter { $0.z == -1 }.count == 1)

        // tile 5 / E
        let n40 = day.findNeighbors(for: Point(4, 0), level: 0)
        #expect(n40.count == 4)
        #expect(n40.filter { $0.z == 0 }.count == 2)
        #expect(n40.filter { $0.z == -1 }.count == 2)

        // tile 14 / N
        let n32 = day.findNeighbors(for: Point(3, 2), level: 0)
        #expect(n32.count == 8)
        #expect(n32.filter { $0.z == 0 }.count == 3)
        #expect(n32.filter { $0.z == 1 }.count == 5)
        #expect(n32.filter { $0.z == 1 }.allSatisfy { $0.x == 4})

        // tile 12 / L
        let n12 = day.findNeighbors(for: Point(1, 2), level: 0)
        #expect(n12.count == 8)
        #expect(n12.filter { $0.z == 0 }.count == 3)
        #expect(n12.filter { $0.z == 1 }.count == 5)
        #expect(n12.filter { $0.z == 1 }.allSatisfy { $0.x == 0})

        // tile 18 / W
        let n23 = day.findNeighbors(for: Point(2, 3), level: 0)
        #expect(n23.count == 8)
        #expect(n23.filter { $0.z == 0 }.count == 3)
        #expect(n23.filter { $0.z == 1 }.count == 5)
        #expect(n23.filter { $0.z == 1 }.allSatisfy { $0.y == 4 })
    }

    @Test func testDay24_part2() throws {
        let day = Day24(input: """
            ....#
            #..#.
            #..##
            ..#..
            #....
            """, generations: 10)
        #expect(day.part2() == 99)
    }

    @Test func testDay24_part1_solution() throws {
        let day = Day24(input: Day24.input)
        #expect(day.part1() == 13500447)
    }

    @Test func testDay24_part2_solution() throws {
        let day = Day24(input: Day24.input)
        #expect(day.part2() == 2120)
    }
}
