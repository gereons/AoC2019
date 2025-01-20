import Testing
@testable import AdventOfCode

@Suite struct Day02Tests {

    private func runIntcode(_ input: [Int], resultIndex: Int = 0) -> Int {
        let vm = IntcodeVM()
        _ = vm.run(program: input)
        return vm.memory[resultIndex]
    }

    @Test func testDay02_part1() throws {
        #expect(runIntcode([1,9,10,3,2,3,11,0,99,30,40,50]) == 3500)
        #expect(runIntcode([1,0,0,0,99]) == 2)
        #expect(runIntcode([2,3,0,3,99], resultIndex: 3) == 6)
        #expect(runIntcode([2,4,4,5,99,0], resultIndex: 5) == 9801)
        #expect(runIntcode([1,1,1,4,99,5,6,0,99]) == 30)
    }

    @Test func testDay02_part1_solution() throws {
        #expect(Day02(input: Day02.input).part1() == 5305097)
    }

    @Test func testDay02_part2_solution() throws {
        #expect(Day02(input: Day02.input).part2() == 4925)
    }
}
