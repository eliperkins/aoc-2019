//
//  Day2.swift
//  Day2
//
//  Created by Eli Perkins on 12/2/19.
//  Copyright © 2019 eliperkins. All rights reserved.
//

import Foundation
import AOCKit

public func process(opcodes: String, replacingMemoryWith values: (Int, Int)? = nil) -> String {
    let stringCodes = Array(
        opcodes
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: ",")
            .map(String.init)
    )
    let intCodes: [Int] = stringCodes.compactMap(Int.init)
    assert(stringCodes.count == intCodes.count, "Failed to convert all string values to integers")

    var returnValues = intCodes

    if let values = values {
        returnValues[1] = values.0
        returnValues[2] = values.1
    }

    let program = returnValues.map(String.init).joined(separator: ",")
    return execute(program: program)
}

public func getInitialOpcodeValue(from opcodes: String) -> Int {
    let stringCodes = Array(
        opcodes
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: ",")
            .map(String.init)
    )
    let intCodes: [Int] = stringCodes.compactMap(Int.init)
    guard let value = intCodes.first else { fatalError("Failed to get initial value") }
    return value
}

public func test(opcodes: String, for match: Int) -> (noun: Int, verb: Int) {
    for noun in 0...99 {
        for verb in 0...99 {
            if getInitialOpcodeValue(from: process(opcodes: opcodes, replacingMemoryWith: (noun, verb))) == match {
                return (noun, verb)
            }
        }
    }
    fatalError("Could not find match!")
}
