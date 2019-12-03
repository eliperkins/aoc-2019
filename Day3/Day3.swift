//
//  Day3.swift
//  Day3
//
//  Created by Eli Perkins on 12/3/19.
//  Copyright © 2019 eliperkins. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation

public func distanceFromCentralPort(for lhs: String, and rhs: String) -> Int {
    let lhsSet = Set(path(from: parse(instructions: lhs)))
    let rhsSet = Set(path(from: parse(instructions: rhs)))

    guard let first = lhsSet.intersection(rhsSet)
        .subtracting(Set([Point(x: 0, y: 0)]))
        .sorted(by: { (l, r) in l.manhattanDistance < r.manhattanDistance })
        .first
        else { fatalError("No intersecting points!") }

    return first.manhattanDistance
}

public func distanceWithShortestSteps(for lhs: String, and rhs: String) -> Int {
    let lhsPath = path(from: parse(instructions: lhs))
    let rhsPath = path(from: parse(instructions: rhs))

    let lhsSet = Set(path(from: parse(instructions: lhs)))
    let rhsSet = Set(path(from: parse(instructions: rhs)))

    let intersections = lhsSet.intersection(rhsSet)
        .subtracting(Set([Point(x: 0, y: 0)]))

    var shortestSteps = Int.max
    for intersection in intersections {
        guard let lhsIndex = lhsPath.firstIndex(of: intersection),
            let rhsIndex = rhsPath.firstIndex(of: intersection)
            else { break }
        let steps = lhsIndex + rhsIndex
        if steps < shortestSteps {
            shortestSteps = steps
        }
    }

    guard shortestSteps != Int.max else { fatalError("Distance not found!") }
    return shortestSteps
}

struct Point: Equatable, Hashable {
    static let zero = Point(x: 0, y: 0)

    let x: Int
    let y: Int

    var manhattanDistance: Int {
        abs(x) + abs(y)
    }
}

func path(from wire: [Instruction]) -> [Point] {
    return wire.reduce([Point(x: 0, y: 0)]) { (acc, next) in
        let currentPoint = acc[acc.endIndex - 1]
        let pointsToAdd: [Point]
        switch next.direction {
        case .up:
            pointsToAdd = stride(from: currentPoint.y + 1, through: currentPoint.y + next.distance, by: 1).map {
                Point(x: currentPoint.x, y: $0)
            }
        case .down:
            pointsToAdd = stride(from: currentPoint.y - 1, through: currentPoint.y - next.distance, by: -1).map {
                Point(x: currentPoint.x, y: $0)
            }
        case .left:
            pointsToAdd = stride(from: currentPoint.x - 1, through: currentPoint.x - next.distance, by: -1).map {
                Point(x: $0, y: currentPoint.y)
            }
        case .right:
            pointsToAdd = stride(from: currentPoint.x + 1, through: currentPoint.x + next.distance, by: 1).map {
                Point(x: $0, y: currentPoint.y)
            }
        }
        return acc + pointsToAdd
    }
}

struct Instruction {
    enum Direction: String {
        case up = "U"
        case down = "D"
        case left = "L"
        case right = "R"
    }

    let direction: Direction
    let distance: Int

    init?(from string: String) {
        guard let direction = Direction(rawValue: String(string[string.startIndex])),
            let distance = Int(String(string.dropFirst()))
            else { return nil }

        self.direction = direction
        self.distance = distance
    }
}

func parse(instructions: String) -> [Instruction] {
    return instructions.split(separator: ",")
        .map(String.init)
        .compactMap(Instruction.init)
}
