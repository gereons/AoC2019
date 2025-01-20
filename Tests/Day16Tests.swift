import Testing
@testable import AdventOfCode

@Suite struct Day16Tests {
//    @Test func testDay16_0() throws {
//        #expect(Day16(input: "12345678").part1() == "00000000")
//    }

    @Test func testDay16_1() throws {
        #expect(Day16(input: "80871224585914546619083218645595").part1() == "24176176")
        #expect(Day16(input: "19617804207202209144916044189917").part1() == "73745418")
        #expect(Day16(input: "69317163492948606335995924319873").part1() == "52432133")
    }

    @Test func testDay16_2() throws {
        #expect(Day16(input: "03036732577212944063491565474664").part2() == "84462026")
        #expect(Day16(input: "02935109699940807407585447034323").part2() == "78725270")
        #expect(Day16(input: "03081770884921959731165446850517").part2() == "53553731")
    }
}
