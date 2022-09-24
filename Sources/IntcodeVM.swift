//
// IntcodeVM.swift
//
// Advent of Code 2019, Days 2, 5 and 9
//

class IntcodeVM {

    enum Opcode: Int {
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
            case .add: return 3
            case .multiply: return 3
            case .input: return 1
            case .output: return 1
            case .jumpIfTrue: return 2
            case .jumpIfFalse: return 2
            case .lessThan: return 3
            case .equals: return 3
            case .relativeBaseOffset: return 1
            case .end: return 0
            }
        }
    }

    enum Mode: Int {
        case position = 0
        case immediate = 1
        case relative = 2
    }

    struct Parameter {
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

    struct Instruction {
        let opcode: Opcode
        let parameters: [Parameter]
    }

    enum RunResult: Equatable {
        case end([Int])
        case awaitingInput
    }

    class Memory {
        fileprivate var storage = [Int: Int]()

        subscript(_ index: Int) -> Int {
            get {
                guard index >= 0 else {
                    fatalError("get invalid address \(index)")
                }
                return storage[index, default: 0]
            }
            set(newValue) {
                guard index >= 0 else {
                    fatalError("set invalid address \(index)")
                }
                storage[index] = newValue
            }
        }
    }

    private var inputs = [Int]()
    private var outputs = [Int]()
    private(set) var memory = Memory()

    private var ic = 0 // input counter
    private var pc = 0 // program counter
    private var rBase = 0 // relative base
    private(set) var steps = 0 // instructions executed so far
    private var finished = false

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
        let result = start(program: program, inputs: inputs, patches: patches)
        switch result {
        case .end(let outputs):
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
        let keysAndValues = program.enumerated().map { ($0.offset, $0.element) }
        memory.storage = Dictionary(uniqueKeysWithValues: keysAndValues)

        for (index, value) in patches {
            memory[index] = value
        }
        self.inputs = inputs
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
        addInput(inputs)

        let instruction = decodeInstruction()
        if instruction.opcode != .input {
            fatalError("not waiting for input...")
        }
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

        pc = 0
        ic = 0
        rBase = 0
        steps = 0
        finished = false

        return execute()
    }

    private func execute() -> RunResult {
        while true {
            let result = executeInstruction()
            switch result {
            case .end:
                finished = true
                return .end(outputs)
            case .awaitingInput:
                return .awaitingInput
            case .newPc(let newPc):
                pc = newPc
            }
        }
    }

    private enum ExecuteResult {
        case end
        case awaitingInput
        case newPc(Int)
    }

    private func executeInstruction() -> ExecuteResult {
        let instruction = decodeInstruction()
        steps += 1

        let p = instruction.parameters
        let opcode = instruction.opcode

        switch opcode {
        case .add:
            assign(p[2], rvalue(p[0]) + rvalue(p[1]))
        case .multiply:
            assign(p[2], rvalue(p[0]) * rvalue(p[1]))
        case .input:
            guard let input = input() else {
                return .awaitingInput
            }
            assign(p[0], input)
        case .output:
            output(rvalue(p[0]))
        case .jumpIfTrue:
            if rvalue(p[0]) != 0 {
                return .newPc(rvalue(p[1]))
            }
        case .jumpIfFalse:
            if rvalue(p[0]) == 0 {
                return .newPc(rvalue(p[1]))
            }
        case .lessThan:
            let result = rvalue(p[0]) < rvalue(p[1]) ? 1 : 0
            assign(p[2], result)
        case .equals:
            let result = rvalue(p[0]) == rvalue(p[1]) ? 1 : 0
            assign(p[2], result)
        case .relativeBaseOffset:
            rBase += rvalue(p[0])
        case .end:
            return .end
        }
        return .newPc(pc + 1 + opcode.parameters)
    }

    private func assign(_ p: Parameter, _ newValue: Int) {
        switch p.mode {
        case .position: memory[p.value] = newValue
        case .relative: memory[rBase + p.value] = newValue
        case .immediate: fatalError("immediate address in lvalue")
        }
    }

    private func rvalue(_ parameter: Parameter) -> Int {
        switch parameter.mode {
        case .position: return memory[parameter.value]
        case .immediate: return parameter.value
        case .relative: return memory[rBase + parameter.value]
        }
    }

    private func decodeInstruction() -> Instruction {
        let (modes, opcode) = memory[pc].quotientAndRemainder(dividingBy: 100)
        guard let opcode = Opcode(rawValue: opcode) else {
            fatalError("invalid opcode \(memory[pc]) at \(ic)")
        }

        let parameters = getParameters(opcode, modes)
        return Instruction(opcode: opcode, parameters: parameters)
    }

    private func getParameters(_ opcode: Opcode, _ modes: Int) -> [Parameter] {
        var parameters = [Parameter]()
        var m = modes
        for i in 0..<opcode.parameters {
            let (quotient, mode) = m.quotientAndRemainder(dividingBy: 10)
            parameters.append(Parameter(value: memory[pc + i + 1], mode: mode))
            m = quotient
        }
        return parameters
    }

    private func input() -> Int? {
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
