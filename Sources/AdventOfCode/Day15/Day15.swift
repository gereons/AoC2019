//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/15
//

import AoCTools

extension Point.Direction {
    var input: Int {
        switch self {
        case .n: return 1
        case .s: return 2
        case .w: return 3
        case .e: return 4
        default: fatalError()
        }
    }
}

private enum Tile: Int {
    case wall = 0
    case floor = 1
    case oxygen = 2
}

private class Grid {
    private(set) var points = [Point: Tile]()

    private(set) var current = Point.zero
    private(set) var direction = Point.Direction.n
    private let droid: IntcodeVM

    init(program: [Int]) {
        droid = IntcodeVM()
        droid.start(program: program)
    }

    func createMap() -> Point {
        var visited = [Point: Int]()
        var oxygen = Point.zero

        while !mapBuilt(visited) {
            direction = chooseDirection()
            let target = current.add(direction.offset)
            assert(points[target] != .wall)
            let result = droid.continue(with: [direction.input])
            switch result {
            case .end: fatalError()
            case .awaitingInput:
                let output = droid.transferOutputs()
                assert(output.count==1)
                let tile = Tile(rawValue: output[0])!
                switch tile {
                case .floor:
                    points[target] = .floor
                    current = target
                    visited[current, default: 0] += 1
                case .wall:
                    points[target] = .wall
                    direction = direction.turned(.counterclockwise)
                case .oxygen:
                    oxygen = target
                    points[target] = .oxygen
                    current = target
                    visited[current, default: 0] += 1
                }
            }

        }
        return oxygen
    }

    func mapBuilt(_ visited: [Point: Int]) -> Bool {
        guard
            let maxX = points.keys.max(by: { $0.x < $1.x})?.x,
            let maxY = points.keys.max(by: { $0.y < $1.y})?.y,
            let minX = points.keys.min(by: { $0.x < $1.x})?.x,
            let minY = points.keys.min(by: { $0.y < $1.y})?.y
        else { return false }

        if abs(minX) + maxX != 40 { return false }
        if abs(minY) + maxY != 40 { return false }
        return visited.values.allSatisfy { $0 > 1 }
    }

    func chooseDirection() -> Point.Direction {
        let rightHand = direction.turned(.clockwise)
        if points[current + rightHand.offset] == .wall {
            if points[current + direction.offset] != .wall {
                return direction
            }
        } else {
            return rightHand
        }

        var dir = direction
        for _ in 0..<3 {
            dir = dir.turned(.counterclockwise)
            if points[current + dir.offset] != .wall {
                return dir
            }
        }
        fatalError()
    }

    func draw() {
        let maxX = points.keys.max { $0.x < $1.x}!.x
        let maxY = points.keys.max { $0.y < $1.y}!.y
        let minX = points.keys.min { $0.x < $1.x}!.x
        let minY = points.keys.min { $0.y < $1.y}!.y
        print(minX, maxX, minY, maxY, points.count, terminator: "\r\n")
        for y in minY...maxY {
            for x in minX...maxX {
                var ch = ""
                let p = Point(x,y)
                switch points[p] {
                case .floor: ch = p == current ? "X" : " "
                case .wall: ch = "#"
                case .oxygen: ch = "o"
                case .none: ch = "."
                }
                if p == .zero { ch = "@" }
                print(ch, terminator: "")
            }
            print("\r")
        }
    }

    func floodFill(startAt start: Point) -> Int {
        let floors = points.values.filter { $0 == .floor }.count

        var minutes = 1
        var filled = [start]
        while filled.count < floors {
            for point in filled {
                let neighbors = point.neighbors().filter { points[$0] == .floor }
                neighbors.forEach {
                    points[$0] = .oxygen
                }
                filled.append(contentsOf: neighbors)
            }
            minutes += 1
            draw()
        }
        return minutes
    }
}

extension Grid: Pathfinding {
    func costToMove(from: Point, to: Point) -> Int {
        1
    }

    func hScore(from: Point, to: Point) -> Int {
        from.distance(to: to)
    }

    func neighbors(for point: Point) -> [Point] {
        point
            .neighbors()
            .filter { points[$0] != .wall }
    }
}

final class Day15: AOCDay {
    let program: [Int]
    init(rawInput: String? = nil) {
        let input = rawInput ?? Self.rawInput
        program = input.components(separatedBy: ",").map { Int($0)! }
    }

    func part1() -> Int {
        let grid = Grid(program: self.program)
        let oxygen = grid.createMap()

        let pathfinder = AStarPathfinder(grid: grid)
        let path = pathfinder.shortestPathFrom(.zero, to: oxygen)

        return path.count - 1
    }

    func part2() -> Int {
        let grid = Grid(program: self.program)
        let oxygen = grid.createMap()

        let minutes = grid.floodFill(startAt: oxygen)
        return minutes
    }
}
