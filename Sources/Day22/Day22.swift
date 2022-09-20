//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/22
//

import AoCTools

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

final class Day22: AOCDay {
    private let shuffles: [Shuffle]
    private(set) var deck: [Int]

    convenience init(rawInput: String? = nil) {
        self.init(rawInput: rawInput, deckSize: 10007)
    }

    init(rawInput: String? = nil, deckSize: Int) {
        let input = rawInput ?? Self.rawInput
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

    func part2() -> Int {
        return 0
    }
}
