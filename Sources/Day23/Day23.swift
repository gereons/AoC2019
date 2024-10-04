//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/23
//

import AoCTools

final class Day23: AOCDay {
    let program: [Int]
    let NAT = 255

    init(input: String) {
        program = input.components(separatedBy: ",").map { Int($0)! }
    }

    func part1() -> Int {
        let nics = (0..<50).map {
            let nic = IntcodeVM(id: "\($0)")
            _ = nic.start(program: program, inputs: [$0, -1])
            return nic
        }

        var queue = [Int: [Int]]()
        while true {
            for i in 0..<50 {
                let output = nics[i].consumeOutput()
                for chunk in output.chunks(ofCount: 3) {
                    let chunk = Array(chunk)
                    let target = chunk[0]
                    if target == NAT {
                        return chunk[2]
                    }
                    queue[target, default: []].append(contentsOf: [chunk[1], chunk[2]])
                }

                if let inputs = queue.removeValue(forKey: i) {
                    _ = nics[i].continue(with: inputs)
                } else {
                    _ = nics[i].continue(with: [-1])
                }
            }
        }
    }

    func part2() -> Int {
        let nics = (0..<50).map {
            let nic = IntcodeVM(id: "\($0)")
            _ = nic.start(program: program, inputs: [$0, -1])
            return nic
        }

        var lastSentY = Int.min
        var queue = [Int: [Int]]()

        while true {
            var allIdle = true

            for i in 0..<50 {
                let output = nics[i].consumeOutput()
                for chunk in output.chunks(ofCount: 3) {
                    allIdle = false
                    queue[chunk.first!, default: []].append(contentsOf: Array(chunk.dropFirst()))
                }

                if let inputs = queue.removeValue(forKey: i) {
                    allIdle = false
                    _ = nics[i].continue(with: inputs)
                } else {
                    _ = nics[i].continue(with: [-1])
                }
            }

            if allIdle, let last = queue[NAT]?.suffix(2) {
                let nat = Array(last)
                if nat[1] == lastSentY {
                    return lastSentY
                }
                lastSentY = nat[1]
                _ = nics[0].continue(with: Array(nat))
            }
        }
    }
}
