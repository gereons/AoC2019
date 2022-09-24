//
// Advent of Code 2019
//
// https://adventofcode.com/2019/day/21
//

import AoCTools

private extension String {
    var ascii: [Int] {
        self.map { Int($0.asciiValue!) }
    }

    init(ints: [Int]) {
        let chars = ints.map { Character(UnicodeScalar($0)!) }
        self.init(chars)
    }
}

final class Day21: AOCDay {
    let program: [Int]
    init(rawInput: String? = nil) {
        let input = rawInput ?? Self.rawInput
        program = input.components(separatedBy: ",").map { Int($0)! }
    }

    func part1() -> Int {
        let vm = IntcodeVM()

        let springscript = """
        NOT A T
        NOT B J
        OR T J
        NOT C T
        OR T J
        AND D J
        WALK\n
        """

        let output = vm.run(program: program, inputs: springscript.ascii)
        print(String(ints: output.filter { $0 < 256 }))

        return output.filter { $0 > 255}.first ?? 0
    }

    func part2() -> Int {
        let vm = IntcodeVM()

        let springscript = """
        NOT A T
        NOT B J
        OR T J
        NOT C T
        OR T J
        AND D J
        NOT I T
        NOT T T
        OR F T
        AND E T
        OR H T
        AND T J
        RUN\n
        """

        let output = vm.run(program: program, inputs: springscript.ascii)
        print(String(ints: output.filter { $0 < 256 }))

        return output.filter { $0 > 255}.first ?? 0
    }
}
