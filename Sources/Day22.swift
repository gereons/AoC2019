//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/22
//

import AoCTools
import BigInt

private enum Shuffle {
    case newStack // deal into new stack
    case cut(Int) // "cut 6"
    case dealIncrement(Int) // "deal with increment 7"

    init(_ str: String) {
        let parts = str.components(separatedBy: " ")
        if parts[1] == "into" {
            self = .newStack
        } else if parts[0] == "cut" {
            self = .cut(Int(parts[1])!)
        } else if parts[1] == "with" {
            self = .dealIncrement(Int(parts[3])!)
        } else {
            fatalError()
        }
    }
}

final class Day22: AdventOfCodeDay {
    let title = "Slam Shuffle"
    
    private let shuffles: [Shuffle]
    let deck: [Int]

    convenience init(input: String) {
        self.init(input: input, deckSize: 10007)
    }

    init(input: String, deckSize: Int) {
        self.shuffles = input.components(separatedBy: "\n").map { Shuffle($0) }
        self.deck = Array(0..<deckSize)
    }

    func part1() -> Int {
        for shuffle in shuffles {
            perform(shuffle)
        }
        let result = deck.enumerated().filter { $0.element == 2019 }
        return result.first?.offset ?? 0
    }

    private func perform(_ shuffle: Shuffle) {
        var deck = self.deck
        switch shuffle {
        case .newStack:
            deck = deck.reversed()
        case .cut(let depth):
            if depth > 0 {
                let top = deck.prefix(depth)
                deck.removeFirst(depth)
                deck = deck + top
            } else {
                let bottom = deck.suffix(-depth)
                deck.removeLast(-depth)
                deck = bottom + deck
            }
        case .dealIncrement(let inc):
            var newDeck = [Int](repeating: -1, count: deck.count)
            var current = 0
            for card in deck {
                newDeck[current % newDeck.count] = card
                current += inc
            }
            assert(newDeck.allSatisfy { $0 != -1 })
            deck = newDeck
        }
    }

    private func perform(_ shuffle: Shuffle, input: inout [BigInt], deckSize: BigInt) {
        switch shuffle {
        case .newStack:
            input[0] = -input[0]
            input[1] = -(input[1] + 1)
        case .cut(let depth):
            input[1] += BigInt(depth)
        case .dealIncrement(let inc):
            let p = BigInt(inc).power(deckSize - 2, modulus: deckSize)
            for i in 0..<input.count {
                input[i] *= p
            }
        }
    }

    // based on
    // https://github.com/SimonBaars/AdventOfCode-Java/blob/0d7b48795ee181d0fc639250b60986842088684f/src/main/java/com/sbaars/adventofcode2019/days/Day22.java
    // no way would i have figured this out myself...
    
    func part2() -> BigInt {
        seekPosition(deckSize: 119315717514047,
                     timesShuffled: 101741582076661,
                     position: 2020)
    }

    private func seekPosition(deckSize: BigInt, timesShuffled: BigInt, position: BigInt) -> BigInt {
        var memory: [BigInt] = [1, 0]
        for shuffle in shuffles.reversed() {
            perform(shuffle, input: &memory, deckSize: deckSize)
            for i in 0..<memory.count {
                memory[i] %= deckSize
            }
        }

        let power = memory[0].power(timesShuffled, modulus: deckSize)
        let p1 = power * position
        let p2 = memory[1] * (power + deckSize - 1)
        let p3 = (memory[0] - 1).power(deckSize - 2, modulus: deckSize)
        return (p1 + p2 * p3) % deckSize
    }
}
