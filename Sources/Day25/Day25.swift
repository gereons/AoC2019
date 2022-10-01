//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/25
//

import AoCTools

final class Day25: AOCDay {
    let program: [Int]
    init(rawInput: String? = nil) {
        let input = rawInput ?? Self.rawInput
        program = input.components(separatedBy: ",").map { Int($0)! }
    }

    func part1() -> Int {
        // interactive()

        findWeight()
        return 0
    }

    func findWeight() {
        let robot = IntcodeVM()

        let status = robot.start(program: program, inputs: Self.setup.ascii)
        assert(status == .awaitingInput)
        print(String(ints: robot.consumeOutput()))

        let items = Set([
            "manifold", "dehydrated water", "polygon", "weather machine",
            "bowl of rice", "hypercube", "candy cane", "dark matter"
        ])

        for carry in combinations(of: items) {
            let take = carry.map { "take \($0)\n".ascii }.flatMap { $0 }
            let drop = carry.map { "drop \($0)\n".ascii }.flatMap { $0 }

            _ = robot.continue(with: take)
            _ = robot.continue(with: "south\n".ascii)
            let output = String(ints: robot.consumeOutput())
            if output.indexOf("Droids on this ship are heavier") != nil {
                _ = robot.continue(with: drop)
                _ = robot.consumeOutput()
            } else if output.indexOf("Droids on this ship are lighter") != nil {
                _ = robot.continue(with: drop)
                _ = robot.consumeOutput()
            } else {
                print("jackpot: \(carry)")
                print(output)
                break
            }
        }
    }

    func combinations<T>(of elements: Set<T>) -> [[T]] {
        var allCombinations: [[T]] = []
        for element in elements {
            let oneElementCombo = [element]
            for i in 0..<allCombinations.count {
                allCombinations.append(allCombinations[i] + oneElementCombo)
            }
            allCombinations.append(oneElementCombo)
        }
        return allCombinations
    }

    func interactive() {
        let robot = IntcodeVM()

        var status = robot.start(program: program)
        while true {
            switch status {
            case .end(let output):
                print(String(ints: output))
                break
            case .awaitingInput:
                let output = robot.consumeOutput()
                print(String(ints: output))

                if let line = readLine(strippingNewline: false) {
                    status = robot.continue(with: line.ascii)
                }
            }
        }
    }

    func part2() {}
}

extension Day25 {
static let setup = """
east
take weather machine
west
west
west
take bowl of rice
east
north
take polygon
east
take hypercube
south
take dark matter
north
west
north
take candy cane
west
north
take manifold
south
west
north
take dehydrated water
west
drop dehydrated water
drop hypercube
drop dark matter
drop polygon
drop manifold
drop candy cane
drop bowl of rice
drop weather machine
inv\n
"""
}
