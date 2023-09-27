import XCTest
import AoCTools
@testable import AdventOfCode

final class Day24Tests: XCTestCase {
    let day = Day24(input: """
            ....#
            #..#.
            #..##
            ..#..
            #....
            """)

    func testDay24_1() throws {
        XCTAssertEqual(day.part1(), 2129920)
    }

    func testRecursiveNeighboursInSameLevel() throws {
        let points = [Point(1,1), Point(3,1), Point(1,3), Point(3,3) ]

        for p in points {
            let n = day.findNeighbors(for: p, level: 1)
            XCTAssertEqual(n.count, 4)
            XCTAssertTrue(n.allSatisfy { $0.z == 1 })
        }
    }

    func testRecursiveNeighboursCorners() throws {
        let points = [Point(0,0), Point(4,0), Point(0,4), Point(4,4) ]

        for p in points {
            let n = day.findNeighbors(for: p, level: 1)
            XCTAssertEqual(n.count, 4)
            XCTAssertEqual(n.filter { $0.z == 1}.count, 2)
            XCTAssertEqual(n.filter { $0.z == 0}.count, 2)
        }
    }

    func testRecursiveNeighboursEdgeOutside() throws {
        let points = [
            Point(1,0), Point(2,0), Point(3,0),
            Point(4,1), Point(4,2), Point(4,3),
            Point(1,4), Point(2,4), Point(3,4),
            Point(0,1), Point(0,2), Point(0,3)
        ]

        for p in points {
            let n = day.findNeighbors(for: p, level: 1)
            XCTAssertEqual(n.count, 4)
            XCTAssertEqual(n.filter { $0.z == 1}.count, 3)
            XCTAssertEqual(n.filter { $0.z == 0}.count, 1)
        }
    }

    func testRecursiveNeighboursCenterInside() throws {
        let points = [ Point(2,1), Point(1,2), Point(3,2), Point(2,3) ]

        for p in points {
            let n = day.findNeighbors(for: p, level: 1)
            XCTAssertEqual(n.count, 8)
            XCTAssertEqual(n.filter { $0.z == 1}.count, 3)
            XCTAssertEqual(n.filter { $0.z == 2}.count, 5)
        }
    }

    func testRecursiveNeighbors() throws {
        let day = Day24(input: """
            ....#
            #..#.
            #..##
            ..#..
            #....
            """, generations: 10)
        // tile 19
        let n33 = day.findNeighbors(for: Point(3, 3), level: 0)
        XCTAssertEqual(n33.count, 4)
        XCTAssertTrue(n33.allSatisfy { $0.z == 0 })

        // tile 7 / G
        let n11 = day.findNeighbors(for: Point(1, 1), level: 17)
        XCTAssertEqual(n11.count, 4)
        XCTAssertTrue(n11.allSatisfy { $0.z == 17 })

        // tile 4 / D
        let n30 = day.findNeighbors(for: Point(3, 0), level: 0)
        XCTAssertEqual(n30.count, 4)
        XCTAssertEqual(n30.filter { $0.z == 0 }.count, 3)
        XCTAssertEqual(n30.filter { $0.z == -1 }.count, 1)

        // tile 5 / E
        let n40 = day.findNeighbors(for: Point(4, 0), level: 0)
        XCTAssertEqual(n40.count, 4)
        XCTAssertEqual(n40.filter { $0.z == 0 }.count, 2)
        XCTAssertEqual(n40.filter { $0.z == -1 }.count, 2)

        // tile 14 / N
        let n32 = day.findNeighbors(for: Point(3, 2), level: 0)
        XCTAssertEqual(n32.count, 8)
        XCTAssertEqual(n32.filter { $0.z == 0 }.count, 3)
        XCTAssertEqual(n32.filter { $0.z == 1 }.count, 5)
        XCTAssertTrue(n32.filter { $0.z == 1 }.allSatisfy { $0.x == 4})

        // tile 12 / L
        let n12 = day.findNeighbors(for: Point(1, 2), level: 0)
        XCTAssertEqual(n12.count, 8)
        XCTAssertEqual(n12.filter { $0.z == 0 }.count, 3)
        XCTAssertEqual(n12.filter { $0.z == 1 }.count, 5)
        XCTAssertTrue(n12.filter { $0.z == 1 }.allSatisfy { $0.x == 0})

        // tile 18 / W
        let n23 = day.findNeighbors(for: Point(2, 3), level: 0)
        XCTAssertEqual(n23.count, 8)
        XCTAssertEqual(n23.filter { $0.z == 0 }.count, 3)
        XCTAssertEqual(n23.filter { $0.z == 1 }.count, 5)
        XCTAssertTrue(n23.filter { $0.z == 1 }.allSatisfy { $0.y == 4 })
    }

    func testDay24_2() throws {
        let day = Day24(input: """
            ....#
            #..#.
            #..##
            ..#..
            #....
            """, generations: 10)
        XCTAssertEqual(day.part2(), 99)
    }
}
