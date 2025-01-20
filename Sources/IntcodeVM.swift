//
// IntcodeVM.swift
//
// Advent of Code 2019, Days 2, 5 and 9
//

final class IntcodeVM {

    private enum Opcode: Int {
        case add = 1
        case multiply = 2
        case input = 3
        case output = 4
        case jumpIfTrue = 5
        case jumpIfFalse = 6
        case lessThan = 7
        case equals = 8
        case relativeBaseOffset = 9
        case end = 99

        var parameters: Int {
            switch self {
            case .add: 3
            case .multiply: 3
            case .input: 1
            case .output: 1
            case .jumpIfTrue: 2
            case .jumpIfFalse: 2
            case .lessThan: 3
            case .equals: 3
            case .relativeBaseOffset: 1
            case .end: 0
            }
        }
    }

    private enum Mode: Int {
        case position = 0
        case immediate = 1
        case relative = 2
    }

    private struct Parameter {
        let value: Int
        let mode: Mode

        init(value: Int, mode: Int) {
            self.value = value
            guard let mode = Mode(rawValue: mode) else {
                fatalError("invalid mode \(mode)")
            }
            self.mode = mode
        }
    }

    private struct Instruction {
        let opcode: Opcode
        let parameters: [Parameter]

        var size: Int { 1 + opcode.parameters }
    }

    final class Memory {
        fileprivate var storage = [Int: Int]()

        subscript(_ address: Int) -> Int {
            get {
                assert(address >= 0)
                return storage[address, default: 0]
            }
            set {
                assert(address >= 0)
                storage[address] = newValue
            }
        }
    }

    private enum State {
        case initial // before running or starting a program
        case running // while running a program
        case finished // after finishing a program
        case awaitingInput // execution halted, can be continued when input is available
    }

    enum RunResult: Equatable {
        case end([Int])
        case awaitingInput
    }

    private var inputs = [Int]()
    private var outputs = [Int]()
    private(set) var memory = Memory()

    private var programCounter = 0
    private var relativeBase = 0

    private var vmState = State.initial

    let id: String

    init(id: String = "") {
        self.id = id
    }

    /// Run an intcode program. All necessary input must be provided up-front
    /// - Parameters:
    ///   - program: the intcode program itself
    ///   - inputs: initial inputs
    ///   - patches: initial memory patches
    /// - Returns: the produced outputs
    func run(program: [Int], inputs: [Int] = [], patches: [Int: Int] = [:]) -> [Int] {
        assert(vmState == .initial || vmState == .finished)
        let result = start(program: program, inputs: inputs, patches: patches)
        switch result {
        case .end(let outputs):
            assert(vmState == .finished)
            return outputs
        case .awaitingInput:
            fatalError("use start()/continue()")
        }
    }

    /// Start an intcode program and run it until it either terminates or reaches an input instruction
    /// with an empty input buffer.
    /// - Parameters:
    ///   - program: the intcode program itself
    ///   - inputs: initial inputs
    ///   - patches: initial memory patches
    /// - Returns: the reason for stopping
    func start(program: [Int], inputs: [Int] = [], patches: [Int: Int] = [:]) -> RunResult {
        assert(vmState == .initial || vmState == .finished)
        let keysAndValues = program.enumerated().map { ($0.offset, $0.element) }
        memory.storage = Dictionary(uniqueKeysWithValues: keysAndValues)

        for (index, value) in patches {
            memory[index] = value
        }
        self.inputs = inputs
        self.outputs = []
        self.programCounter = 0
        defer { assert(vmState == .finished || vmState == .awaitingInput) }
        return run()
    }

    /// Continue running a program that was previously stopped at an input instruction
    /// - Parameter input: the input
    /// - Returns: the reason for stopping
    func `continue`(with input: Int) -> RunResult {
        self.continue(with: [input])
    }

    /// Continue running a program that was previously stopped at an input instruction
    /// - Parameter inputs: the inputs
    /// - Returns: the reason for stopping
    func `continue`(with inputs: [Int]) -> RunResult {
        assert(vmState == .awaitingInput)
        addInput(inputs)

        let instruction = decodeInstruction(at: programCounter)
        if instruction.opcode != .input {
            fatalError("not waiting for input")
        }
        defer { assert(vmState == .finished || vmState == .awaitingInput) }
        return execute()
    }

    /// Add input data, but don't continue execution
    /// - Parameter input: input data
    func addInput(_ input: Int) {
        inputs.append(input)
    }

    /// Add input data, but don't continue execution
    /// - Parameter inputs: input data
    func addInput(_ inputs: [Int]) {
        self.inputs.append(contentsOf: inputs)
    }

    /// Get output data accumulated so far and clear the VM's output buffer
    /// - Returns: output accumulated so far
    func consumeOutput() -> [Int] {
        defer { outputs = [] }
        return outputs
    }

    private func run() -> RunResult {
        guard !memory.storage.isEmpty else {
            fatalError("IntcodeVM: uninitialized memory")
        }

        return execute()
    }

    private func execute() -> RunResult {
        vmState = .running
        while true {
            let result = executeInstruction(at: programCounter)
            switch result {
            case .end:
                vmState = .finished
                return .end(outputs)
            case .awaitingInput:
                vmState = .awaitingInput
                return .awaitingInput
            case .setProgramCounter(let newPc):
                programCounter = newPc
            }
        }
    }

    private enum ExecuteResult {
        case end
        case awaitingInput
        case setProgramCounter(Int)
    }

    private func executeInstruction(at address: Int) -> ExecuteResult {
        let instruction = decodeInstruction(at: address)
        let p = instruction.parameters
        let opcode = instruction.opcode

        switch opcode {
        case .add:
            assign(p[2], rvalue(p[0]) + rvalue(p[1]))
        case .multiply:
            assign(p[2], rvalue(p[0]) * rvalue(p[1]))
        case .input:
            guard let input = consumeInput() else {
                return .awaitingInput
            }
            assign(p[0], input)
        case .output:
            output(rvalue(p[0]))
        case .jumpIfTrue:
            if rvalue(p[0]) != 0 {
                return .setProgramCounter(rvalue(p[1]))
            }
        case .jumpIfFalse:
            if rvalue(p[0]) == 0 {
                return .setProgramCounter(rvalue(p[1]))
            }
        case .lessThan:
            let result = rvalue(p[0]) < rvalue(p[1]) ? 1 : 0
            assign(p[2], result)
        case .equals:
            let result = rvalue(p[0]) == rvalue(p[1]) ? 1 : 0
            assign(p[2], result)
        case .relativeBaseOffset:
            relativeBase += rvalue(p[0])
        case .end:
            return .end
        }
        return .setProgramCounter(address + instruction.size)
    }

    private func assign(_ parameter: Parameter, _ newValue: Int) {
        switch parameter.mode {
        case .position: memory[parameter.value] = newValue
        case .relative: memory[relativeBase + parameter.value] = newValue
        case .immediate: fatalError("immediate address in lvalue")
        }
    }

    private func rvalue(_ parameter: Parameter) -> Int {
        switch parameter.mode {
        case .position: return memory[parameter.value]
        case .relative: return memory[relativeBase + parameter.value]
        case .immediate: return parameter.value
        }
    }

    private func decodeInstruction(at address: Int) -> Instruction {
        let value = memory[address]
        assert(value > 0 && value < 100_000)
        let (modes, opcode) = value.quotientAndRemainder(dividingBy: 100)
        guard let opcode = Opcode(rawValue: opcode) else {
            fatalError("invalid opcode \(memory[address]) at \(address)")
        }

        let parameters = getParameters(for: opcode, at: address + 1, modes)
        return Instruction(opcode: opcode, parameters: parameters)
    }

    private func getParameters(for opcode: Opcode, at address: Int, _ modes: Int) -> [Parameter] {
        var parameters = [Parameter]()
        var modes = modes
        for i in 0..<opcode.parameters {
            let (quotient, mode) = modes.quotientAndRemainder(dividingBy: 10)
            parameters.append(Parameter(value: memory[address + i], mode: mode))
            modes = quotient
        }
        return parameters
    }

    private func consumeInput() -> Int? {
        guard let input = inputs.first else {
            return nil
        }

        inputs.remove(at: 0)
        return input
    }

    private func output(_ n: Int) {
        outputs.append(n)
    }
}
