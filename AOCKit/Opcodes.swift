//
//  Opcodes.swift
//  AOCKit
//
//  Created by Eli Perkins on 12/6/19.
//  Copyright © 2019 eliperkins. All rights reserved.
//
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length
// swiftlint:disable function_parameter_count

import Foundation

public enum Opcode: Int {
    case addition = 1
    case multiplication = 2
    case input = 3
    case output = 4
    case jumpIfTrue = 5
    case jumpIfFalse = 6
    case lessThan = 7
    case equals = 8
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

    case jumpIfTrue(test: Int, pointer: Int)
    case jumpIfFalse(test: Int, pointer: Int)
    case lessThan(lhs: Int, rhs: Int, pointer: Int)
    case equals(lhs: Int, rhs: Int, pointer: Int)

    case halt
}

func execute(
    instruction: Instruction,
    instructionPointer: inout Int,
    with memory: inout [Int],
    input: Int,
    output: inout Int,
    shouldContinue: inout Bool
) {
    switch instruction {
    case .addition(let lhs, let rhs, let pointer):
        memory[pointer] = lhs + rhs
    case .multiplication(let lhs, let rhs, let pointer):
        memory[pointer] = lhs * rhs
    case .input(let pointer):
        memory[pointer] = input
    case .output(let pointer):
        output = pointer
        dump(output)
    case .jumpIfTrue(let test, let pointer):
        if test != 0 {
            instructionPointer = pointer
        } else {
            instructionPointer = instructionPointer.advanced(by: 3)
        }
    case .jumpIfFalse(let test, let pointer):
        if test == 0 {
            instructionPointer = pointer
        } else {
            instructionPointer = instructionPointer.advanced(by: 3)
        }
    case .lessThan(let lhs, let rhs, let pointer):
        if lhs < rhs {
            memory[pointer] = 1
        } else {
            memory[pointer] = 0
        }
    case .equals(let lhs, let rhs, let pointer):
        if lhs == rhs {
            memory[pointer] = 1
        } else {
            memory[pointer] = 0
        }
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
    case .jumpIfTrue:
        let parameterModes = getParameterModes(from: remaining, length: 2)
        let valuePointer = instructionPointer.advanced(by: 1)
        let valueMode = parameterModes[parameterModes.startIndex]
        let value = getValue(with: valueMode, address: valuePointer, from: memory)

        let pointerMode = parameterModes[parameterModes.startIndex + 1]
        let pointer = getValue(with: pointerMode, address: valuePointer.advanced(by: 1), from: memory)

        return .jumpIfTrue(test: value, pointer: pointer)
    case .jumpIfFalse:
        let parameterModes = getParameterModes(from: remaining, length: 2)
        let valuePointer = instructionPointer.advanced(by: 1)
        let valueMode = parameterModes[parameterModes.startIndex]
        let value = getValue(with: valueMode, address: valuePointer, from: memory)

        let pointerMode = parameterModes[parameterModes.startIndex + 1]
        let pointer = getValue(with: pointerMode, address: valuePointer.advanced(by: 1), from: memory)

        return .jumpIfFalse(test: value, pointer: pointer)
    case .lessThan:
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

        return .lessThan(lhs: lhs, rhs: rhs, pointer: outputAddress)
    case .equals:
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

        return .equals(lhs: lhs, rhs: rhs, pointer: outputAddress)
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

@discardableResult
public func execute(program: String, input: Int = 1, output: inout Int) -> String {
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
            execute(
                instruction: instruction,
                instructionPointer: &instructionPointer,
                with: &memory,
                input: input,
                output: &output,
                shouldContinue: &shouldContinue
            )
        } else {
            instructionPointer = instructionPointer.advanced(by: 1)
        }
    }
    return memory.map(String.init).joined(separator: ",")
}
