//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/17
//

import AoCTools

private enum Tile {
    case wall
    case floor
    case robot

    var draw: String {
        switch self {
        case .wall: return "#"
        case .floor: return "."
        case .robot: return "@"
        }
    }
}

private struct Grid {
    let points: [Point: Tile]
    let maxX: Int
    let maxY: Int

    func isJunction(_ point: Point) -> Bool {
        guard let tile = points[point], tile == .wall else { return false }

        let neighbors = point.neighbors()
        return neighbors.allSatisfy { points[$0] == .wall }
    }

    func draw() {
        for y in 0...maxY {
            for x in 0...maxX {
                let ch: String
                switch points[Point(x,y)] {
                case .wall: ch = "#"
                case .floor: ch = "."
                case .robot: ch = "^"
                case .none: ch = "?"
                }
                print(ch, terminator: "")
            }
            print()
        }
    }
}

private extension Point {
    var alignment: Int { x * y }
}

final class Day17: AOCDay {
    let program: [Int]

    init(input: String) {
        program = input.components(separatedBy: ",").map { Int(String($0))! }
    }

    func part1() -> Int {
        let (grid, _) = createGrid()

        return grid.points
            .filter { $0.value == .wall }
            .filter { grid.isJunction($0.key) }
            .map { $0.key }
            .reduce(0) { $0 + $1.alignment }
    }

    private func createGrid() -> (Grid, Point) {
        let ascii = IntcodeVM()
        let output = ascii.run(program: program)

        var grid = [Point: Tile]()
        var robot: Point?
        var y = 0
        var x = 0
        for ch in output {
            let point = Point(x,y)
            switch ch {
            case 35: grid[point] = .wall
            case 46: grid[point] = .floor
            case 94: grid[point] = .robot; robot = point
            case 10:
                y += 1
                x = 0
                continue
            default: print(ch)
            }
            x += 1
        }

        let maxX = grid.keys.max { $0.x < $1.x }!.x
        let maxY = grid.keys.max { $0.y < $1.y }!.y
        return (Grid(points: grid, maxX: maxX, maxY: maxY), robot!)
    }

    func part2() -> Int {
        let ascii = IntcodeVM()

        var inputs = asASCII("A,B,A,C,A,B,C,B,C,B\n")
        inputs.append(contentsOf: asASCII("R,10,R,10,R,6,R,4\n"))
        inputs.append(contentsOf: asASCII("R,10,R,10,L,4\n"))
        inputs.append(contentsOf: asASCII("R,4,L,4,L,10,L,10\n"))
        inputs.append(contentsOf: asASCII("n\n"))

        let output = ascii.run(program: program, inputs: inputs, patches: [0: 2])
        return output.last ?? 0
    }

    func asASCII(_ string: String) -> [Int] {
        string.compactMap { Int($0.asciiValue!) }
    }

    func pathSequence() -> Int {
        let (grid, robot) = createGrid() // testGrid()
        grid.draw()

        var current = robot
        var direction = Direction.n

        var segments = [String]()
        var currentSegment = 0

        while true {
            let next = current + direction.offset
            if grid.points[next] == .wall {
                currentSegment += 1
                current = next
            } else {
                segments.append("\(currentSegment)")
                currentSegment = 0
                let possibleTurns: [Turn] = [.clockwise, .counterclockwise]
                    .filter { grid.points[direction.turned($0).offset + current] == .wall }
                if possibleTurns.isEmpty {
                    break
                } else {
                    direction = direction.turned(possibleTurns[0])
                    segments.append(possibleTurns[0] == .clockwise ? "R" : "L")
                }
            }
        }

        segments.remove(at: 0)
        print(segments)
        return 0
    }
}

extension Day17 {
    private func testGrid() -> (Grid, Point) {
        let input = """
        #######...#####
        #.....#...#...#
        #.....#...#...#
        ......#...#...#
        ......#...###.#
        ......#.....#.#
        ^########...#.#
        ......#.#...#.#
        ......#########
        ........#...#..
        ....#########..
        ....#...#......
        ....#...#......
        ....#...#......
        ....#####......
        """
        var points = [Point: Tile]()
        var robot: Point?
        for (y, line) in input.components(separatedBy: "\n").enumerated() {
            for (x, ch) in line.enumerated() {
                let point = Point(x,y)
                switch ch {
                case "#": points[point] = .wall
                case ".": points[point] = .floor
                case "^": points[point] = .wall; robot = point
                default: fatalError()
                }
            }
        }

        let maxX = points.keys.max { $0.x < $1.x }!.x
        let maxY = points.keys.max { $0.y < $1.y }!.y
        return (Grid(points: points, maxX: maxX, maxY: maxY), robot!)
    }
}
