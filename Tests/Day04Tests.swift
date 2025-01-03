import XCTest
@testable import AdventOfCode

final class Day04Tests: XCTestCase {
    func testDay04_1() throws {
        XCTAssertEqual(Day04.isValidPassword(111111), true)
        XCTAssertEqual(Day04.isValidPassword(223450), false)
        XCTAssertEqual(Day04.isValidPassword(223450), false)
    }

    func testDay04_2() throws {
        XCTAssertEqual(Day04.isValidPassword2(111111), false)
        XCTAssertEqual(Day04.isValidPassword2(223450), false)
        XCTAssertEqual(Day04.isValidPassword2(223450), false)

        XCTAssertEqual(Day04.isValidPassword2(112233), true)
        XCTAssertEqual(Day04.isValidPassword2(123444), false)
        XCTAssertEqual(Day04.isValidPassword2(111122), true)

        XCTAssertEqual(Day04.isValidPassword2(112333), true)
        XCTAssertEqual(Day04.isValidPassword2(112344), true)
    }
}
