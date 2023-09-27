//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/7
//

import AoCTools

final class Day07: AOCDay {
    let program: [Int]
    init(input: String? = nil) {
        let input = input ?? Self.input
        program = input.components(separatedBy: ",").map { Int($0)! }
    }

    func part1() -> Int {
        var maxSignal = 0
        [0,1,2,3,4].permutations { phaseSetting in
            maxSignal = max(maxSignal, thrusterSignal(program: program, phaseSetting: phaseSetting))
        }
        return maxSignal
    }

    func part2() -> Int {
        var maxSignal = 0
        [5,6,7,8,9].permutations { phaseSetting in
            maxSignal = max(maxSignal, thrusterSignalFeedback(program: program, phaseSetting: phaseSetting))
        }
        return maxSignal
    }

    func thrusterSignal(program: [Int], phaseSetting: [Int]) -> Int {
        var ampOutput = 0
        for phase in phaseSetting {
            let vm = IntcodeVM()
            let outputs = vm.run(program: program, inputs: [phase, ampOutput])
            ampOutput = outputs[0]
        }
        return ampOutput
    }

    func thrusterSignalFeedback(program: [Int], phaseSetting: [Int]) -> Int {
        var firstInput = [0]
        let amps = phaseSetting.enumerated().map { index, phase in
            let vm = IntcodeVM(id: "\(index)")
            let result = vm.start(program: program, inputs: [phase] + firstInput)
            firstInput = []
            assert(result == .awaitingInput)
            return vm
        }

        var currentAmp = 0
        var done = 0
        var lastOutput = 0
        while true {
            let amp = amps[currentAmp % amps.count]
            currentAmp += 1
            let nextAmp = amps[currentAmp % amps.count]

            let result = amp.continue(with: [])
            switch result {
            case .awaitingInput:
                let outputs = amp.consumeOutput()
                nextAmp.addInput(outputs)
            case .end(let outputs):
                nextAmp.addInput(outputs)
                lastOutput = outputs.last ?? 0
                done += 1
            }
            if done == amps.count {
                break
            }

        }

        return lastOutput
    }
}
