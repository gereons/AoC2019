import XCTest
@testable import AdventOfCode

final class Day05Tests: XCTestCase {
    func testDay05_1() throws {
        let vm = IntcodeVM()
        let outputs = vm.run(program: [3,0,4,0,99], inputs: [99])
        XCTAssertEqual(outputs, [99])
    }
}
