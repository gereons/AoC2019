//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/3
//

import AoCTools

final class Day02: AdventOfCodeDay {
    let title = "1202 Program Alarm"
    
    let program: [Int]
    
    init(input: String) {
        program = input.components(separatedBy: ",").map { Int($0)! }
    }

    func part1() -> Int {
        result(for: 12, 2)
    }

    func part2() -> Int {
        for noun in 0..<100 {
            for verb in 0..<100 {
                if result(for: noun, verb) == 19690720 {
                    return 100 * noun + verb
                }
            }
        }
        fatalError()
    }

    private func result(for noun: Int, _ verb: Int) -> Int {
        let vm = IntcodeVM()
        _ = vm.run(program: program, patches: [1: noun, 2: verb])
        return vm.memory[0]
    }
}
