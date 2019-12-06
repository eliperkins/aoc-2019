//
//  Day4Tests.swift
//  Day4Tests
//
//  Created by Eli Perkins on 12/4/19.
//  Copyright © 2019 eliperkins. All rights reserved.
//

import XCTest
@testable import Day4

class Day4Tests: XCTestCase {

    func testPartOneExamples() {
        XCTAssertEqual(check(password: "111111", enforceDuplicates: false), true)
        XCTAssertEqual(check(password: "223450", enforceDuplicates: false), false)
        XCTAssertEqual(check(password: "123789", enforceDuplicates: false), false)
    }

    func testPartOneAnswer() {
        let range = 402328...864247
        let count = range.reduce(into: 0) { (acc, next) in
            let password = String(next)
            if check(password: password, enforceDuplicates: false) {
                acc += 1
            }
        }

        XCTAssertEqual(count, 454)
    }

    func testPartTwoExamples() {
        XCTAssertEqual(check(password: "112233"), true)
        XCTAssertEqual(check(password: "123444"), false)
        XCTAssertEqual(check(password: "111122"), true)
    }

    func testPartTwoAnswer() {
        let range = 402328...864247
        let count = range.reduce(into: 0) { (acc, next) in
            let password = String(next)
            if check(password: password) {
                acc += 1
            }
        }

        XCTAssertEqual(count, 288)
    }

}
