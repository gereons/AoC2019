//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/8
//

import AoCTools
import Algorithms

final class Day08: AdventOfCodeDay {
    let title = "Space Image Format"
    
    let layers: [[Int]]

    init(input: String) {
        let digits = input.map { Int(String($0))! }
        layers = digits.chunks(ofCount: 25*6).map { [Int]($0) }
        assert(layers.allSatisfy { $0.count == 25 * 6})
    }

    func part1() -> Int {
        let least0 = layers.min { count0(in: $0) < count0(in: $1) }!
        let c1 = least0.filter { $0 == 1 }
        let c2 = least0.filter { $0 == 2 }
        return c1.count * c2.count
    }

    func count0(in array: [Int]) -> Int {
        array.filter { $0 == 0}.count
    }

    enum Pixel: Int {
        case black
        case white
        case transparent
    }

    func part2() -> String {
        var composed = [Int]()

        for i in 0..<layers[0].count {
            let color = topColor(at: i)
            composed.append(color)
        }

        let lines = composed.chunks(ofCount: 25)
        for line in lines {
            for pixel in line {
                let ch: String
                switch pixel {
                case 0: ch = " "
                case 1: ch = "#"
                case 2: ch = " "
                default: fatalError()
                }
                print(ch, terminator: "")
            }
            print()
        }
        return "KAUZA"
    }

    private func topColor(at index: Int) -> Int {
        for i in 0..<layers.count {
            let pixel = layers[i][index]
            if pixel == 2 { continue }
            return pixel
        }
        return 2
    }
}
