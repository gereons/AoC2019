//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/9
//

import AoCTools

final class Day09: AOCDay {
    let program: [Int]
    init(rawInput: String? = nil) {
        let input = rawInput ?? Self.rawInput
        program = input.components(separatedBy: ",").map { Int($0)! }
    }

    func part1() -> Int {
        let vm = IntcodeVM()
        vm.initialMemory = program
        vm.inputs = [1]
        vm.run()
        return vm.outputs[0]
    }

    func part2() -> Int {
        let vm = IntcodeVM()
        vm.initialMemory = program
        vm.inputs = [2]
        vm.run()
        return vm.outputs[0]
    }
}
