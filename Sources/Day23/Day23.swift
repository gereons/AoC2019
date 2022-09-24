//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/23
//

import AoCTools

final class Day23: AOCDay {
    let program: [Int]
    init(rawInput: String? = nil) {
        let input = rawInput ?? Self.rawInput
        program = input.components(separatedBy: ",").map { Int($0)! }
    }

    func part1() -> Int {
        let nics = (0..<50).map {
            let nic = IntcodeVM(id: "\($0)")
            let status = nic.start(program: program, inputs: [$0])
            assert(status == .awaitingInput)
            return nic
        }

        var queue = [Int: [Int]]()
        while true {
            for i in 0..<50 {
                let output = nics[i].consumeOutput()
                for chunk in output.chunked(3) {
                    assert(chunk.count == 3)
                    let target = chunk[0]
                    if target == 255 {
                        return chunk[2]
                    }
                    queue[target, default: []].append(contentsOf: [chunk[1], chunk[2]])
                }
                if let inputs = queue.removeValue(forKey: i) {
                    let status = nics[i].continue(with: inputs)
                    assert(status == .awaitingInput)
                } else {
                    let status = nics[i].continue(with: [-1])
                    assert(status == .awaitingInput)
                }
            }
        }
    }

    func part2() -> Int {
        let nics = (0..<50).map {
            let nic = IntcodeVM(id: "\($0)")
            let status = nic.start(program: program, inputs: [$0])
            assert(status == .awaitingInput)
            return nic
        }

        var nat = [Int]()
        var queue = [Int: [Int]]()
        var idleLoops = 0
        while true {
            var allIdle = true
            for i in 0..<50 {
                if let inputs = queue.removeValue(forKey: i) {
                    allIdle = false
                    let status = nics[i].continue(with: inputs)
                    assert(status == .awaitingInput)
                } else {
                    let status = nics[i].continue(with: [-1])
                    assert(status == .awaitingInput)
                }
            }

            for i in 0..<50 {
                let output = nics[i].consumeOutput()
                for chunk in output.chunked(3) {
                    allIdle = false
                    let target = chunk[0]
                    let packet = Array(chunk.dropFirst())
                    if target == 255 {
                        if !nat.isEmpty && packet[1] == nat[1] {
                            return nat[1]
                        }
                        nat = packet
                    } else {
                        queue[target, default: []].append(contentsOf: packet)
                    }
                }
            }

            if allIdle {
                idleLoops += 1
            } else {
                idleLoops = 0
            }

            if idleLoops == 100 && !nat.isEmpty {
                let status = nics[0].continue(with: nat)
                assert(status == .awaitingInput)
            }
        }
    }
}
