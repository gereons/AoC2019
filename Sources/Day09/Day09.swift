//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/9
//

import AoCTools

final class Day09: AOCDay {
    let program: [Int]
    
    init(input: String) {
        program = input.components(separatedBy: ",").map { Int($0)! }
    }

    func part1() -> Int {
        let vm = IntcodeVM()
        let outputs = vm.run(program: program, inputs: [1])
        return outputs[0]
    }

    func part2() -> Int {
        let vm = IntcodeVM()
        let outputs = vm.run(program: program, inputs: [2])
        return outputs[0]
    }
}
