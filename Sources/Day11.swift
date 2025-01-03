//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/11
//

import AoCTools

final class Day11: AdventOfCodeDay {
    let title = "Space Police"
    
    let program: [Int]
    init(input: String) {
        program = input.components(separatedBy: ",").map { Int($0)! }
    }

    func part1() -> Int {
        var grid = [Point: Int]()
        paint(&grid)
        return grid.values.count
    }

    func paint(_ grid: inout [Point: Int]) {
        let robot = IntcodeVM()
        let status = robot.start(program: program)
        assert(status == .awaitingInput)

        var position = Point.zero
        var direction = Direction.n

        while true {
            let result = robot.continue(with: grid[position, default: 0])
            switch result {
            case .awaitingInput:
                let outputs = robot.consumeOutput()
                assert(outputs.count == 2)
                grid[position] = outputs[0]
                let turn = outputs[1] == 0 ? Turn.counterclockwise : .clockwise
                direction = direction.turned(turn)
                position = position + direction.offset
            case .end:
                return
            }
        }
    }

    func part2() -> String {
        var grid = [Point: Int]()
        grid[.zero] = 1

        paint(&grid)

        let maxX = grid.keys.max { $0.x < $1.x }!.x
        let maxY = grid.keys.max { $0.y < $1.y }!.y

        for y in 0...maxY {
            for x in 0...maxX {
                let ch = grid[Point(x,y), default: 0] == 0 ? " " : "#"
                print(ch, terminator: "")
            }
            print()
        }
        return "HJKJKGPH"
    }
}
