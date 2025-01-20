import Testing
@testable import AdventOfCode

@Suite struct Day09Tests {
    @Test func testDay09_part1() throws {
        let vm = IntcodeVM()
        var program = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
        var outputs = vm.run(program: program)
        #expect(outputs == program)

        program = [1102,34915192,34915192,7,4,7,99,0]
        outputs = vm.run(program: program)
        #expect(String(outputs[0]).count == 16)

        program = [104,1125899906842624,99]
        outputs = vm.run(program: program)

        #expect(outputs[0] == program[1])
    }

    @Test func testDay09_part1_solution() throws {
        let day = Day09(input: Day09.input)
        #expect(day.part1() == 3533056970)
    }

    @Test func testDay09_part2_solution() throws {
        let day = Day09(input: Day09.input)
        #expect(day.part2() == 72852)
    }
}
