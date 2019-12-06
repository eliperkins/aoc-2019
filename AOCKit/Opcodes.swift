//
//  Opcodes.swift
//  AOCKit
//
//  Created by Eli Perkins on 12/6/19.
//  Copyright © 2019 eliperkins. All rights reserved.
//

import Foundation

public enum Opcode: Int {
    case addition = 1
    case multiplication = 2
    case input = 3
    case output = 4
    case halt = 99
}

public enum ParameterMode: Int {
    case position = 0
    case immediate = 1
}

public enum Instruction {
    case addition(lhs: Int, rhs: Int, pointer: Int)
    case multiplication(lhs: Int, rhs: Int, pointer: Int)
    case input(pointer: Int)
    case output(pointer: Int)
    case halt
}

func execute(instruction: Instruction, with memory: inout [Int], shouldContinue: inout Bool) {
    switch instruction {
    case .addition(let lhs, let rhs, let pointer):
        memory[pointer] = lhs + rhs
    case .multiplication(let lhs, let rhs, let pointer):
        memory[pointer] = lhs * rhs
    case .input(let pointer):
        memory[pointer] = 1
    case .output(let pointer):
        dump(pointer)
//        dump(memory[pointer])
    case .halt:
        shouldContinue = false
    }
}

func getParameterModes(from values: [Int], length: Int) -> [ParameterMode] {
    let given = values.compactMap(ParameterMode.init)
    return given + Array(repeating: .position, count: length - given.count)
}

func getValue(with mode: ParameterMode, address: Int, from memory: [Int]) -> Int {
    switch mode {
    case .immediate:
        return memory[address]
    case .position:
        let pointer = memory[address]
        return memory[pointer]
    }
}

func process(value: Int, instructionPointer: inout Int, from memory: [Int]) -> Instruction? {
    let stringValue = String(value)
    let values = stringValue.compactMap({ $0.wholeNumberValue })
    let remaining = Array(values.dropLast(2).reversed())

    guard let opcodeValue = Int(stringValue.suffix(2)),
        let opcode = Opcode(rawValue: opcodeValue)
        else { return nil }
    switch opcode {
    case .addition:
        let parameterModes = getParameterModes(from: remaining, length: 3)
        let lhsMode = parameterModes[parameterModes.startIndex]
        let rhsMode = parameterModes[parameterModes.startIndex + 1]

        let lhsAddress = instructionPointer.advanced(by: 1)
        let rhsAddress = instructionPointer.advanced(by: 2)
        let outputIndex = instructionPointer.advanced(by: 3)

        let outputAddress = memory[outputIndex]
        let lhs = getValue(with: lhsMode, address: lhsAddress, from: memory)
        let rhs = getValue(with: rhsMode, address: rhsAddress, from: memory)

        instructionPointer = outputIndex.advanced(by: 1)

        return .addition(lhs: lhs, rhs: rhs, pointer: outputAddress)
    case .multiplication:
        let parameterModes = getParameterModes(from: remaining, length: 3)
        let lhsMode = parameterModes[parameterModes.startIndex]
        let rhsMode = parameterModes[parameterModes.startIndex + 1]

        let lhsAddress = instructionPointer.advanced(by: 1)
        let rhsAddress = instructionPointer.advanced(by: 2)
        let outputIndex = instructionPointer.advanced(by: 3)

        let outputAddress = memory[outputIndex]
        let lhs = getValue(with: lhsMode, address: lhsAddress, from: memory)
        let rhs = getValue(with: rhsMode, address: rhsAddress, from: memory)

        instructionPointer = outputIndex.advanced(by: 1)

        return .multiplication(lhs: lhs, rhs: rhs, pointer: outputAddress)
    case .input:
        let address = instructionPointer.advanced(by: 1)
        let pointer = getValue(with: .immediate, address: address, from: memory)

        instructionPointer = instructionPointer.advanced(by: 2)

        return .input(pointer: pointer)
    case .output:
        let address = instructionPointer.advanced(by: 1)
        let pointer = getValue(with: .position, address: address, from: memory)

        instructionPointer = instructionPointer.advanced(by: 2)

        return .output(pointer: pointer)
    case .halt:
        return .halt
    }

}

func createMemory(from input: String) -> [Int] {
    let stringCodes = Array(
        input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: ",")
            .map(String.init)
    )
    let intCodes = stringCodes.compactMap(Int.init)
    assert(stringCodes.count == intCodes.count, "Failed to convert all string values to integers")
    return intCodes
}

public func execute(program: String) -> String {
    let stringCodes = Array(
        program
           .trimmingCharacters(in: .whitespacesAndNewlines)
           .split(separator: ",")
           .map(String.init)
    )
    var memory = createMemory(from: program)
    var instructionPointer = 0
    var shouldContinue = true
    while instructionPointer < stringCodes.endIndex && shouldContinue {
        let memoryAtAddress = memory[instructionPointer]

        let instruction = process(
            value: memoryAtAddress,
            instructionPointer: &instructionPointer,
            from: memory
        )
        if let instruction = instruction {
            execute(instruction: instruction, with: &memory, shouldContinue: &shouldContinue)
        } else {
            instructionPointer = instructionPointer.advanced(by: 1)
        }
    }
    return memory.map(String.init).joined(separator: ",")
}
