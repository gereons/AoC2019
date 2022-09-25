//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/24
//

import AoCTools

private enum Tile: Drawable, Hashable, Equatable {
    case bug
    case empty

    var draw: String {
        switch self {
        case .bug: return "#"
        case .empty: return "."
        }
    }

    init(_ ch: Character) {
        switch ch {
        case "#": self = .bug
        case ".": self = .empty
        default: fatalError("invalid tile \(ch)")
        }
    }

    static func value(for str: String) -> Tile {
        switch str {
        case "#": return .bug
        case ".": return .empty
        default: fatalError("invalid tile \(str)")
        }
    }
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
}

final class Day24: AOCDay {
    private let grid: Grid<Tile>
    init(rawInput: String? = nil) {
        let input = rawInput ?? Self.rawInput

        self.grid = Grid.parse(input.components(separatedBy: "\n"))
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
        return 0
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
