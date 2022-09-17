//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/19
//

import AoCTools

final class Day19: AOCDay {
    let program: [Int]
    init(rawInput: String? = nil) {
        let input = rawInput ?? Self.rawInput
        program = input.components(separatedBy: ",").map { Int($0)! }
    }

    private func checkTractorBeam(at x: Int, y: Int) -> Bool {
        let vm = IntcodeVM()
        let result = vm.run(program: self.program, inputs: [x, y])
        return result.last! == 1
    }

    func part1() -> Int {
        var sum = 0
        for x in 0..<50 {
            for y in 0..<50 {
                if checkTractorBeam(at: x, y: y) {
                    sum += 1
                }
            }
        }

        return sum
    }

    func part2() -> Int {
        var x = 0
        var y = 0

        while true {
            while !checkTractorBeam(at: x, y: y + 99) {
                x += 1
            }
            if checkTractorBeam(at: x + 99, y: y) {
                return x * 10_000 + y
            }
            y += 1
        }
    }
}
