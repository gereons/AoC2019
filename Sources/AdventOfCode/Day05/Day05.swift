//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/5
//

import AoCTools

final class Day05: AOCDay {
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
        return vm.outputs.last!
    }

    func part2() -> Int {
        let vm = IntcodeVM()
        vm.initialMemory = program
        vm.inputs = [5]
        vm.run()
        return vm.outputs.last!
    }
}
