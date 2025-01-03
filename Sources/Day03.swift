//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/3
//

import AoCTools

private enum Direction {
    case up(Int)
    case right(Int)
    case down(Int)
    case left(Int)

    var offset: Point {
        switch self {
        case .up: return AoCTools.Direction.s.offset
        case .down: return AoCTools.Direction.n.offset
        case .left: return AoCTools.Direction.w.offset
        case .right: return AoCTools.Direction.e.offset
        }
    }

    init(_ string: String) {
        let len = Int(string.dropFirst())!
        switch string.prefix(1) {
        case "U": self = .up(len)
        case "D": self = .down(len)
        case "L": self = .left(len)
        case "R": self = .right(len)
        default: fatalError()
        }
    }
}

final class Day03: AdventOfCodeDay {
    let title = "Crossed Wires"
    
    private let wires: [[Direction]]

    init(input: String) {
        let lines = input.components(separatedBy: "\n")
        wires = lines.map {
            $0.components(separatedBy: ",").map { Direction($0) }
        }
    }

    func part1() -> Int {
        let points = wires.map { pointsOn($0) }
        var crossings = Set(points[0].keys).intersection(points[1].keys)
        crossings.remove(.zero)

        let min = crossings.min { $0.distance() < $1.distance() }
        return min?.distance() ?? 0
    }

    func part2() -> Int {
        let points = wires.map { pointsOn($0) }
        var crossings = Set(points[0].keys).intersection(points[1].keys)
        crossings.remove(.zero)

        var minSteps = Int.max
        for x in crossings {
            let steps0 = points[0][x]!
            let steps1 = points[1][x]!

            minSteps = min(minSteps, steps0 + steps1)
        }
        return minSteps
    }

    private func pointsOn(_ wire: [Direction]) -> [Point: Int] {
        var start = Point.zero
        var points = [Point: Int]()

        var steps = 1
        for step in wire {
            let path = move(start, by: step)
            path.forEach {
                if points[$0] == nil { points[$0] = steps }
                steps += 1
            }
            start = path.last!
        }
        return points
    }

    private func move(_ point: Point, by step: Direction) -> [Point] {
        var points = [Point]()
        var next = point
        switch step {
        case .down(let len), .up(let len), .left(let len), .right(let len):
            for _ in 0..<len {
                next = next + step.offset
                points.append(next)
            }
        }
        return points
    }
}
