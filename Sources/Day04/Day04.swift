//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/4
//

import AoCTools

final class Day04: AOCDay {
    let range: ClosedRange<Int>
    init(rawInput: String? = nil) {
        let input = rawInput ?? Self.rawInput
        let range = input.components(separatedBy: "-").map { Int($0)! }
        self.range = range[0]...range[1]
    }

    func part1() -> Int {
        range
            .map { $0 }
            .filter { isValidPassword($0) }
            .count
    }

    func isValidPassword(_ n: Int) -> Bool {
        let s = String(n)
        let digits = s.map { $0 }

        if Set(digits).count == digits.count { return false }
        for index in 0..<digits.count - 1 {
            if digits[index] > digits[index+1] { return false }
        }
        return true
    }

    func part2() -> Int {
        range
            .map { $0 }
            .filter { isValidPassword2($0) }
            .count
    }

    func isValidPassword2(_ n: Int) -> Bool {
        let s = String(n)
        let digits = s.map { $0 }

        if Set(digits).count == digits.count { return false }
        for index in 0..<digits.count - 1 {
            if digits[index] > digits[index+1] { return false }
        }
        var counts = [Character: Int]()
        digits.forEach {
            counts[$0, default: 0] += 1
        }
        let c = counts
            .filter { $0.value > 1 }
            .min { $0.value < $1.value }!

        return c.value == 2
    }
}
