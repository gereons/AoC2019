//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/5
//

import AoCTools

final class Day05: AOCDay {
    let program: [Int]
    init(input: String? = nil) {
        let input = input ?? Self.input
        program = input.components(separatedBy: ",").map { Int($0)! }
    }

    func part1() -> Int {
        let vm = IntcodeVM()
        let outputs = vm.run(program: program, inputs: [1])
        return outputs.last!
    }

    func part2() -> Int {
        let vm = IntcodeVM()
        let outputs = vm.run(program: program, inputs: [5])
        return outputs.last!
    }
}
