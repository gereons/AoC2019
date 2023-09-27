//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/16
//

import AoCTools
import Darwin

final class Day16: AOCDay {
    let digits: [Int]
    let rawInput: String

    init(input: String? = nil) {
        let input = input ?? Self.input
        rawInput = input
        digits = input.map { Int(String($0))! }
    }

    func part1() -> String {
        let result = fft(self.digits)
        return result.prefix(8).map { String($0) }.joined()
    }

    private func fft(_ digits: [Int]) -> [Int] {
        var digits = digits

        var sign = 1
        for _ in 1...100 {
            for j in 0..<digits.count {
                sign = 1
                let ranges = ranges(digits.count, j+1)
                let sum = ranges.reduce(0) {
                    defer {  sign = -sign }
                    return $0 + $1.reduce(0) { $0 + digits[$1] } * sign
                }
                digits[j] = abs(sum) % 10
            }
        }
        return digits
    }

    func ranges(_ count: Int, _ size: Int) -> [ClosedRange<Int>] {
        let ranges = stride(from: size-1, through: count-1, by: size * 2)
            .map { start in
                start...(min(start + size - 1, count-1))
            }
        return ranges
    }

    func lastDigit(_ n: Int) -> Int {
        abs(n) % 10
    }

    // each digit is formed by taking the sum of all digits from its index to the end of the input, i.e. all digits to
    // the right of it. keep the last digit of this sum
    // this means that anything to the left of the message offset can be ignored
    func part2() -> String {
        let offset = Int(String(rawInput.prefix(7)))!

        // get the part of the input we're interested in
        var input = (offset ... 10000 * digits.count).map {
            digits[$0 % digits.count]
        }

        for _ in 1...100 {
            var acc = 0

            // calculate sum from the right going left and store for the next pass
            input.indices.reversed().forEach { idx in
                let sum = input[idx] + acc
                input[idx] = lastDigit(sum)
                acc = sum
            }

        }
        return input.prefix(8).map { String($0) }.joined()
    }
}
