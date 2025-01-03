//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/24
//

import AoCTools

private enum Tile: Character, Drawable, Hashable, Equatable {
    case bug = "#"
    case empty = "."
}

extension Grid where Value == Tile {
    var rating: Int {
        var shift = 0
        var rating = 0
        for y in 0...maxY {
            for x in 0...maxX {
                if points[Point(x,y)] == .bug {
                    rating += 1 << shift
                }
                shift += 1
            }
        }
        return rating
    }

    var isEmpty: Bool {
        points.allSatisfy { $0.value == .empty }
    }
}

final class Day24: AdventOfCodeDay {
    let title = "Planet of Discord"
    
    private let grid: Grid<Tile>
    let generations: Int

    convenience init(input: String) {
        self.init(input: input, generations: 200)
    }

    init(input: String, generations: Int) {
        self.grid = Grid.parse(input.components(separatedBy: "\n"))
        self.generations = generations
    }

    func part1() -> Int {
        var seen = Set<Grid<Tile>>()

        seen.insert(grid)

        var loop = 0
        var current = grid
        while true {
            current = nextGeneration(from: current)
            if seen.contains(current) {
                break
            }
            seen.insert(current)
            loop += 1
        }

        return current.rating
    }

    func part2() -> Int {
        var grids = [Int: Grid<Tile>]()

        let points = (0..<5).map { x in
            (0..<5).map { y in
                Point(x,y)
            }
        }.flatMap { $0 }.map { ($0, Tile.empty) }
        let empty = Grid(points: Dictionary(uniqueKeysWithValues: points))

        grids[0] = self.grid
        for _ in 0..<generations {
            // print(gen, grids.keys)
            nextRecursiveGeneration(in: &grids, emptyGrid: empty)
        }

        return grids.values.reduce(0) { sum, grid in
            sum + grid.points.values.reduce(0) { $0 + ($1 == .bug ? 1 : 0) }
        }
    }

    func findNeighbors(for point: Point, level: Int) -> [Point3] {
        var neighbors = [Point3]()
        for n in point.neighbors() {
            if n.x < 0 {
                neighbors.append(Point3(1, 2, level - 1))
            } else if n.x > 4 {
                neighbors.append(Point3(3, 2, level - 1))
            } else if n.y < 0 {
                neighbors.append(Point3(2, 1, level - 1))
            } else if n.y > 4 {
                neighbors.append(Point3(2, 3, level - 1))
            } else if n.x == 2 && n.y == 2 {
                var fixed = -1
                var row = true
                if point.x == 1 {
                    fixed = 0; row = false
                }
                if point.x == 3 {
                    fixed = 4; row = false
                }
                if point.y == 1 {
                    fixed = 0
                }
                if point.y == 3 {
                    fixed = 4
                }
                assert(fixed != -1)
                if row {
                    neighbors.append(contentsOf: (0..<5).map { Point3($0, fixed, level + 1) })
                } else {
                    neighbors.append(contentsOf: (0..<5).map { Point3(fixed, $0, level + 1) })
                }
            } else {
                neighbors.append(Point3(n.x, n.y, level))
            }
        }
        assert(neighbors.count == 4 || neighbors.count == 8)
        assert(!neighbors.contains { $0.x == 2 && $0.y == 2})
        return neighbors
    }

    private func nextRecursiveGeneration(in grids: inout [Int: Grid<Tile>], emptyGrid: Grid<Tile>) {
        var result = [Int: Grid<Tile>]()

        var levels = grids.keys.sorted(by: <)
        levels.append(levels.last! + 1)
        levels.insert(levels.first! - 1, at: 0)
        grids[levels.first!] = emptyGrid
        grids[levels.last!] = emptyGrid

        for level in levels {
            let grid = grids[level]!
            var newPoints = [Point: Tile]()
            newPoints[Point(2,2)] = .empty
            for (point, tile) in grid.points {
                if point.x == 2 && point.y == 2 { continue }
                let neighbors = findNeighbors(for: point, level: level)

                let bugs = neighbors.reduce(0) { count, point in
                    count + (grids[point.z]?.points[Point(point.x, point.y)] == .bug ? 1 : 0)
                }
                // print(level, point.x, point.y, bugs)
                switch tile {
                case .bug:
                    newPoints[point] = bugs == 1 ? .bug : .empty
                case .empty:
                    newPoints[point] = (bugs == 1 || bugs == 2) ? .bug : .empty
                }
            }
            assert(newPoints.count == 25)
            result[level] = Grid(points: newPoints)
        }

        grids = result
    }

    private func nextGeneration(from grid: Grid<Tile>) -> Grid<Tile> {
        var result = [Point: Tile]()

        for (point, tile) in grid.points {
            let neighbors = point.neighbors().filter { grid.points[$0] != nil }
            let bugs = neighbors.reduce(0) { $0 + (grid.points[$1] == .bug ? 1 : 0) }
            switch tile {
            case .bug:
                result[point] = bugs == 1 ? .bug : .empty
            case .empty:
                result[point] = (bugs == 1 || bugs == 2) ? .bug : .empty
            }
        }

        return Grid(points: result)
    }
}
