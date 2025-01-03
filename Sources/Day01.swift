//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/1
//

import AoCTools

final class Day01: AdventOfCodeDay {
    let title = "The Tyranny of the Rocket Equation"
    
    let modules: [Int]
    
    init(input: String) {
        modules = input.components(separatedBy: "\n").map { Int($0)! }
    }

    func part1() -> Int {
        modules.reduce(0) { $0 + fuel(for: $1) }
    }

    func part2() -> Int {
        var total = 0
        for mod in modules {
            var fuel = fuel(for: mod)
            total += fuel
            while true {
                fuel = self.fuel(for: fuel)
                if fuel > 0 {
                    total += fuel
                } else {
                    break
                }
            }
        }
        return total
    }

    private func fuel(for weight: Int) -> Int {
        (weight / 3) - 2
    }
}
