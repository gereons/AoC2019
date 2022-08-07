import XCTest
@testable import AdventOfCode

final class Day05Tests: XCTestCase {
    func testDay05_1() throws {
        let vm = IntcodeVM()
        vm.initialMemory = [3,0,4,0,99]
        vm.inputs = [99]
        vm.run()
        XCTAssertEqual(vm.outputs, [99])
    }
}
