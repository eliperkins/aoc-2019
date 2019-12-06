//
//  Day4.swift
//  Day4
//
//  Created by Eli Perkins on 12/4/19.
//  Copyright © 2019 eliperkins. All rights reserved.
//

import Foundation

struct CheckState {
    let isIncreasing: Bool
    let adjacentsSet: Set<Int>
    let failedSet: Set<Int>
}

public func check(password: String, enforceDuplicates: Bool = true) -> Bool {
    // It is a six-digit number.
    if password.count != 6 {
        return false
    }

    let initialState = CheckState(
        isIncreasing: true,
        adjacentsSet: Set(),
        failedSet: Set()
    )

    let check = zip(password.enumerated(), password.dropFirst().enumerated())
        .reduce(initialState) { (acc, next) in
            let lhsTuple = next.0
            let rhsTuple = next.1
            guard let lhs = Int(String(lhsTuple.element)),
                let rhs = Int(String(rhsTuple.element))
                else { fatalError("Encountered not integer in string!") }

            // Two adjacent digits are the same (like 22 in 122345).
            let currentPairIsAdjacent = lhs == rhs

            var adjacentsSet = acc.adjacentsSet
            var failedSet = acc.failedSet
            if currentPairIsAdjacent {
                if enforceDuplicates {
                    // The two adjacent matching digits are not part of a larger group of
                    // matching digits.
                    if acc.adjacentsSet.contains(lhs) || acc.failedSet.contains(lhs) {
                        adjacentsSet.remove(lhs)
                        failedSet.insert(lhs)
                    } else {
                        adjacentsSet.insert(lhs)
                    }
                } else {
                    adjacentsSet.insert(lhs)
                }
            }

            // Going from left to right, the digits never decrease; they only ever
            // increase or stay the same (like 111123 or 135679).
            let isIncreasing = rhs >= lhs

            return CheckState(
                isIncreasing: acc.isIncreasing && isIncreasing,
                adjacentsSet: adjacentsSet,
                failedSet: failedSet
            )
        }

    return check.isIncreasing && check.adjacentsSet.count >= 1
}
