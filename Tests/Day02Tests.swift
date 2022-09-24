import XCTest
@testable import AdventOfCode

final class Day02Tests: XCTestCase {

    private func runIntcode(_ input: [Int], resultIndex: Int = 0) -> Int {
        let vm = IntcodeVM()
        _ = vm.run(program: input)
        return vm.memory[resultIndex]
    }

    func testDay02_1() throws {
        XCTAssertEqual(runIntcode([1,9,10,3,2,3,11,0,99,30,40,50]), 3500)
        XCTAssertEqual(runIntcode([1,0,0,0,99]), 2)
        XCTAssertEqual(runIntcode([2,3,0,3,99], resultIndex: 3), 6)
        XCTAssertEqual(runIntcode([2,4,4,5,99,0], resultIndex: 5), 9801)
        XCTAssertEqual(runIntcode([1,1,1,4,99,5,6,0,99]), 30)
    }
}
