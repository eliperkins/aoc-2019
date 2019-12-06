//
//  OpcodesTests.swift
//  AOCKitTests
//
//  Created by Eli Perkins on 12/6/19.
//  Copyright © 2019 eliperkins. All rights reserved.
//

import Foundation
import AOCKit
import XCTest

final class OpcodesTests: XCTestCase {
    func testImmediateMode() {
        let input = "1002,4,3,4,33"
        execute(program: input)
    }
}
