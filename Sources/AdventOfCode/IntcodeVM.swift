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

    @discardableResult
    func run(program: [Int], inputs: [Int] = [], patches: [Int: Int] = [:]) -> [Int] {
        let keysAndValues = program.enumerated().map { ($0.offset, $0.element) }
        memory.storage = Dictionary(uniqueKeysWithValues: keysAndValues)

        for (index, value) in patches {
            memory[index] = value
        }
        self.inputs = inputs
        run()
        return outputs
    }

    private func run() {
        guard !memory.storage.isEmpty else {
            fatalError("IntcodeVM: uninitialized memory")
        }

        pc = 0
        ic = 0
        rBase = 0
        while let newPc = executeInstruction() {
            pc = newPc
        }
    }

    private func executeInstruction() -> Int? {
        let instruction = decodeInstruction()

        let p = instruction.parameters
        let opcode = instruction.opcode

        switch opcode {
        case .add:
            assign(p[2], rvalue(p[0]) + rvalue(p[1]))
        case .multiply:
            assign(p[2], rvalue(p[0]) * rvalue(p[1]))
        case .input:
            assign(p[0], input())
        case .output:
            output(rvalue(p[0]))
        case .jumpIfTrue:
            if rvalue(p[0]) != 0 {
                return rvalue(p[1])
            }
        case .jumpIfFalse:
            if rvalue(p[0]) == 0 {
                return rvalue(p[1])
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
            return nil
        }
        return pc + 1 + opcode.parameters
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

    private func input() -> Int {
        guard ic < inputs.count else {
            fatalError("no input available, ic=\(ic)")
        }

        defer { ic += 1}
        return inputs[ic]
    }

    private func output(_ n: Int) {
        outputs.append(n)
    }
}
