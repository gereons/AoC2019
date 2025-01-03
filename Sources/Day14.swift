//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/14
//

import AoCTools
import OpenGL

private struct Ingredient: CustomStringConvertible {
    let amount: Int
    let name: String

    init(_ string: String) {
        let parts = string.components(separatedBy: " ")
        amount = Int(parts[0])!
        name = parts[1]
    }

    var description: String {
        "\(amount) \(name)"
    }
}

private struct Reaction: CustomStringConvertible {
    let input: [Ingredient]
    let output: Ingredient

    init(_ string: String) {
        let parts = string.components(separatedBy: " => ")
        input = parts[0].components(separatedBy: ", ").map { Ingredient($0) }
        output = Ingredient(parts[1])
    }

    func produces(oneOf names: [String]) -> Bool {
        names.contains(output.name)
    }

    var fromOre: Bool {
        input[0].name == "ORE"
    }

    var description: String {
        "\(input) => \(output)"
    }
}

final class Day14: AdventOfCodeDay {
    let title = "Space Stoichiometry"
    
    private let reactions: [Reaction]
    private var producers = [String: Reaction]()
    private var inventory = [String: Int]()

    init(input: String) {
        reactions = input.components(separatedBy: "\n").map { Reaction($0) }
        producers = Dictionary(uniqueKeysWithValues: zip(reactions.map { $0.output.name}, reactions))
    }

    func part1() -> Int {
        let ore = need(1, "FUEL")
        return ore
    }

    private func need(_ amount: Int, _ stuff: String) -> Int {
        if stuff == "ORE" {
            return amount
        }

        let have = inventory[stuff] ?? 0
        var required = amount
        if have > 0 {
            inventory[stuff] = max(0, have - amount)
            required = amount - have
        }

        if required > 0 {
            let producer = producers[stuff]!
            let iterations = factor(required, producer.output.amount)
            let produced = producer.output.amount * iterations

            if required < produced {
                inventory[stuff, default: 0] += produced - required
            }

            return producer.input.reduce(0) {
                $0 + need($1.amount * iterations, $1.name)
            }
        }
        return 0
    }

    private func factor(_ a: Int, _ b: Int) -> Int {
        (a + b - 1) / b
    }

    func part2() -> Int {
        let ore = 1000000000000

        let fuel1 = need(1, "FUEL")

        let range = 1 ... ore/fuel1 * 2
        let index = range.binarySearch {
            need($0, "FUEL") <= ore
        }

        let fuel = range.distance(from: range.startIndex, to: index)
        return fuel
    }
}

extension RandomAccessCollection {
    func binarySearch(predicate: (Iterator.Element) -> Bool) -> Index {
        var low = startIndex
        var high = endIndex
        while low != high {
            let mid = index(low, offsetBy: distance(from: low, to: high)/2)
            if predicate(self[mid]) {
                low = index(after: mid)
            } else {
                high = mid
            }
        }
        return low
    }
}
