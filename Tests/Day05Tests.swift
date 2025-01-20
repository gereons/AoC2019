import Testing
@testable import AdventOfCode

@Suite struct Day05Tests {
    @Test func testDay05_part1() throws {
        var vm = IntcodeVM()
        let outputs = vm.run(program: [3,0,4,0,99], inputs: [199])
        #expect(outputs == [199])

        vm = IntcodeVM()
        let _ = vm.run(program: [1002,4,3,4,33], inputs: [])
        #expect(vm.memory[4] == 99)

        vm = IntcodeVM()
        let _ = vm.run(program: [1101,100,-1,4,0], inputs: [])
        #expect(vm.memory[4] == 99)

        // 3,9,8,9,10,9,4,9,99,-1,8 - Using position mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
        let o1 = IntcodeVM().run(program: [3,9,8,9,10,9,4,9,99,-1,8], inputs: [8])
        #expect(o1[0] == 1)

        let o2 = IntcodeVM().run(program: [3,9,8,9,10,9,4,9,99,-1,8], inputs: [9])
        #expect(o2[0] == 0)
    }

    @Test func testDay05_part2() throws {
        // 3,9,7,9,10,9,4,9,99,-1,8 - Using position mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
        let o1 = IntcodeVM().run(program: [3,9,7,9,10,9,4,9,99,-1,8], inputs: [8])
        #expect(o1[0] == 0)

        let o2 = IntcodeVM().run(program: [3,9,7,9,10,9,4,9,99,-1,8], inputs: [9])
        #expect(o2[0] == 0)

        let o3 = IntcodeVM().run(program: [3,9,7,9,10,9,4,9,99,-1,8], inputs: [7])
        #expect(o3[0] == 1)

        // 3,3,1108,-1,8,3,4,3,99 - Using immediate mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
        let o4 = IntcodeVM().run(program: [3,3,1108,-1,8,3,4,3,99], inputs: [8])
        #expect(o4[0] == 1)

        let o5 = IntcodeVM().run(program: [3,3,1108,-1,8,3,4,3,99], inputs: [9])
        #expect(o5[0] == 0)

        let o6 = IntcodeVM().run(program: [3,3,1108,-1,8,3,4,3,99], inputs: [7])
        #expect(o6[0] == 0)

        // 3,3,1107,-1,8,3,4,3,99 - Using immediate mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
        let o7 = IntcodeVM().run(program: [3,3,1107,-1,8,3,4,3,99], inputs: [8])
        #expect(o7[0] == 0)

        let o8 = IntcodeVM().run(program: [3,3,1107,-1,8,3,4,3,99], inputs: [9])
        #expect(o8[0] == 0)

        let o9 = IntcodeVM().run(program: [3,3,1107,-1,8,3,4,3,99], inputs: [7])
        #expect(o9[0] == 1)

        // Here are some jump tests that take an input, then output 0 if the input was zero or 1 if the input was non-zero:
        let o10 = IntcodeVM().run(program: [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], inputs: [0])
        #expect(o10[0] == 0)
        let o11 = IntcodeVM().run(program: [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], inputs: [1])
        #expect(o11[0] == 1)

        let o12 = IntcodeVM().run(program: [3,3,1105,-1,9,1101,0,0,12,4,12,99,1], inputs: [0])
        #expect(o12[0] == 0)
        let o13 = IntcodeVM().run(program: [3,3,1105,-1,9,1101,0,0,12,4,12,99,1], inputs: [2])
        #expect(o13[0] == 1)

        let program = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
        1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
        999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]
        // The above example program uses an input instruction to ask for a single number. The program will then output 999 if the input value is below 8, output 1000 if the input value is equal to 8, or output 1001 if the input value is greater than 8.

        let o14 = IntcodeVM().run(program: program, inputs: [-1000])
        #expect(o14[0] == 999)
        let o15 = IntcodeVM().run(program: program, inputs: [8])
        #expect(o15[0] == 1000)
        let o16 = IntcodeVM().run(program: program, inputs: [999])
        #expect(o16[0] == 1001)
    }

    @Test func testDay05_part1_solution() throws {
        #expect(Day05(input: Day05.input).part1() == 16348437)
    }

    @Test func testDay05_part2_solution() throws {
        #expect(Day05(input: Day05.input).part2() == 6959377)
    }
}
