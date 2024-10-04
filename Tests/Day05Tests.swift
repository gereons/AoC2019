import XCTest
@testable import AdventOfCode

@MainActor
final class Day05Tests: XCTestCase {
    func testDay05_1a() throws {
        let vm = IntcodeVM()
        let outputs = vm.run(program: [3,0,4,0,99], inputs: [199])
        XCTAssertEqual(outputs, [199])
    }

    func testDay05_1b() throws {
        let vm = IntcodeVM()
        let _ = vm.run(program: [1002,4,3,4,33], inputs: [])
        XCTAssertEqual(vm.memory[4], 99)
    }

    func testDay05_1c() throws {
        let vm = IntcodeVM()
        let _ = vm.run(program: [1101,100,-1,4,0], inputs: [])
        XCTAssertEqual(vm.memory[4], 99)
    }

    func testDay05_2a() throws {
        // 3,9,8,9,10,9,4,9,99,-1,8 - Using position mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
        let o1 = IntcodeVM().run(program: [3,9,8,9,10,9,4,9,99,-1,8], inputs: [8])
        XCTAssertEqual(o1[0], 1)

        let o2 = IntcodeVM().run(program: [3,9,8,9,10,9,4,9,99,-1,8], inputs: [9])
        XCTAssertEqual(o2[0], 0)
    }

    func testDay05_2b() throws {
        // 3,9,7,9,10,9,4,9,99,-1,8 - Using position mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
        let o1 = IntcodeVM().run(program: [3,9,7,9,10,9,4,9,99,-1,8], inputs: [8])
        XCTAssertEqual(o1[0], 0)

        let o2 = IntcodeVM().run(program: [3,9,7,9,10,9,4,9,99,-1,8], inputs: [9])
        XCTAssertEqual(o2[0], 0)

        let o3 = IntcodeVM().run(program: [3,9,7,9,10,9,4,9,99,-1,8], inputs: [7])
        XCTAssertEqual(o3[0], 1)
    }

    func testDay05_2c() throws {
        // 3,3,1108,-1,8,3,4,3,99 - Using immediate mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
        let o1 = IntcodeVM().run(program: [3,3,1108,-1,8,3,4,3,99], inputs: [8])
        XCTAssertEqual(o1[0], 1)

        let o2 = IntcodeVM().run(program: [3,3,1108,-1,8,3,4,3,99], inputs: [9])
        XCTAssertEqual(o2[0], 0)

        let o3 = IntcodeVM().run(program: [3,3,1108,-1,8,3,4,3,99], inputs: [7])
        XCTAssertEqual(o3[0], 0)
    }

    func testDay05_2d() throws {
        // 3,3,1107,-1,8,3,4,3,99 - Using immediate mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
        let o1 = IntcodeVM().run(program: [3,3,1107,-1,8,3,4,3,99], inputs: [8])
        XCTAssertEqual(o1[0], 0)

        let o2 = IntcodeVM().run(program: [3,3,1107,-1,8,3,4,3,99], inputs: [9])
        XCTAssertEqual(o2[0], 0)

        let o3 = IntcodeVM().run(program: [3,3,1107,-1,8,3,4,3,99], inputs: [7])
        XCTAssertEqual(o3[0], 1)
    }

    func testDay05_2e() throws {
        // Here are some jump tests that take an input, then output 0 if the input was zero or 1 if the input was non-zero:
        let o1 = IntcodeVM().run(program: [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], inputs: [0])
        XCTAssertEqual(o1[0], 0)
        let o2 = IntcodeVM().run(program: [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], inputs: [1])
        XCTAssertEqual(o2[0], 1)

        let o3 = IntcodeVM().run(program: [3,3,1105,-1,9,1101,0,0,12,4,12,99,1], inputs: [0])
        XCTAssertEqual(o3[0], 0)
        let o4 = IntcodeVM().run(program: [3,3,1105,-1,9,1101,0,0,12,4,12,99,1], inputs: [2])
        XCTAssertEqual(o4[0], 1)
    }

    func testDay05_2f() throws {
        let program = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
        1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
        999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]
        // The above example program uses an input instruction to ask for a single number. The program will then output 999 if the input value is below 8, output 1000 if the input value is equal to 8, or output 1001 if the input value is greater than 8.

        let o1 = IntcodeVM().run(program: program, inputs: [-1000])
        XCTAssertEqual(o1[0], 999)
        let o2 = IntcodeVM().run(program: program, inputs: [8])
        XCTAssertEqual(o2[0], 1000)
        let o3 = IntcodeVM().run(program: program, inputs: [999])
        XCTAssertEqual(o3[0], 1001)
    }
}
