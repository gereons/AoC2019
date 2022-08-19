//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/13
//

import AoCTools

enum Tile: Int {
    case empty
    case wall
    case block
    case paddle
    case ball

    var ch: String {
        switch self {
        case .empty: return " "
        case .wall: return "|"
        case .block: return "#"
        case .paddle: return "-"
        case .ball: return "*"
        }
    }
}

final class Day13: AOCDay {
    let program: [Int]
    init(rawInput: String? = nil) {
        let input = rawInput ?? Self.rawInput
        program = input.components(separatedBy: ",").map { Int($0)! }
    }

    func part1() -> Int {
        let game = IntcodeVM()
        game.run(program: self.program)

        let outputs = game.transferOutputs()
        let grid = makeGrid(outputs)

        return grid.values.filter { $0 == .block }.count
    }

    func makeGrid(_ outputs: [Int]) -> [Point: Tile] {
        var grid = [Point: Tile]()
        assert(outputs.count.isMultiple(of: 3))
        for chunk in outputs.chunked(3) {
            let point = Point(chunk[0], chunk[1])
            let tile = Tile(rawValue: chunk[2])!
            grid[point] = tile
        }
        return grid
    }

    func makeGrid(_ outputs: [Int], _ ball: inout Point, _ paddle: inout Point, _ score: inout Int) -> [Point: Tile] {
        var grid = [Point: Tile]()
        assert(outputs.count.isMultiple(of: 3))
        for chunk in outputs.chunked(3) {
            let point = Point(chunk[0], chunk[1])
            if point.x == -1 && point.y == 0 {
                score = chunk[2]
                continue
            }
            let tile = Tile(rawValue: chunk[2])!
            grid[point] = tile
            if tile == .ball {
                ball = point
            } else if tile == .paddle {
                paddle = point
            }
        }
        return grid
    }

    func draw(_ grid: [Point: Tile]) {
        let maxX = grid.keys.max { $0.x < $1.x }!.x
        let maxY = grid.keys.max { $0.y < $1.y }!.y
        for y in 0...maxY {
            for x in 0...maxX {
                let tile = grid[Point(x,y), default: .empty]
                print(tile.ch, terminator: "")
            }
            print()
        }
    }

    func part2() -> Int {
        let game = IntcodeVM()
        let result = game.start(program: self.program, patches: [0: 2])
        if case IntcodeVM.RunResult.end = result {
            fatalError()
        }

        var ball = Point.zero
        var paddle = Point.zero
        var score = 0
        var grid = makeGrid(game.transferOutputs(), &ball, &paddle, &score)
        while true {
            var joystick = 0
            if ball.x > paddle.x {
                joystick = 1
            }
            if ball.x < paddle.x {
                joystick = -1
            }
            let result = game.continue(with: joystick)
            grid[ball] = nil
            grid[paddle] = nil
            _ = makeGrid(game.transferOutputs(), &ball, &paddle, &score)
            grid[ball] = .ball
            grid[paddle] = .paddle
            if case IntcodeVM.RunResult.end = result {
                break
            }
        }

        return score
    }
}
