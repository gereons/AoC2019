import XCTest
@testable import AdventOfCode

final class Day09Tests: XCTestCase {
    func testDay09_1() throws {
        let program = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
        let vm = IntcodeVM()
        vm.initialMemory = program
        vm.run()

        XCTAssertEqual(vm.outputs, program)
    }

    func testDay09_2() throws {
        let program = [1102,34915192,34915192,7,4,7,99,0]
        let vm = IntcodeVM()
        vm.initialMemory = program
        vm.run()

        XCTAssertEqual(String(vm.outputs[0]).count, 16)
    }

    func testDay09_3() throws {
        let program = [104,1125899906842624,99]
        let vm = IntcodeVM()
        vm.initialMemory = program
        vm.run()

        XCTAssertEqual(vm.outputs, [1125899906842624])
    }

}
