//
//  Day1Tests.swift
//  Day1Tests
//
//  Created by Eli Perkins on 12/1/19.
//  Copyright © 2019 eliperkins. All rights reserved.
//

import XCTest
import Day1

class Day1Tests: XCTestCase {

    func testPartOneTestCases() {
        XCTAssertEqual(calculateFuel(for: 12), 2)
        XCTAssertEqual(calculateFuel(for: 14), 2)
        XCTAssertEqual(calculateFuel(for: 1969), 654)
        XCTAssertEqual(calculateFuel(for: 100756), 33583)
    }

    func testPartOneAnswer() {
        var result = 0
        testInput.enumerateLines { (line, _) in
            guard let mass = Int(line) else {
                fatalError("Line is not an Int: \(line)")
            }

            result += calculateFuel(for: mass)
        }
        XCTAssertEqual(result, 3317668)
    }

    func testPartTwoTestCases() {
        XCTAssertEqual(calculateFuelAccountingForAdditionalMass(for: 12), 2)
        XCTAssertEqual(calculateFuelAccountingForAdditionalMass(for: 1969), 966)
        XCTAssertEqual(calculateFuelAccountingForAdditionalMass(for: 100756), 50346)
    }

    func testPartTwoAnswer() {
        var result = 0
        testInput.enumerateLines { (line, _) in
            guard let mass = Int(line) else {
                fatalError("Line is not an Int: \(line)")
            }

            result += calculateFuelAccountingForAdditionalMass(for: mass)
        }
        XCTAssertEqual(result, 4973628)
    }
}

let testInput = """
60566
53003
132271
130557
109138
64818
123247
148493
98275
67155
132365
133146
88023
92978
122790
84429
93421
76236
104387
135953
131379
125949
133614
94647
64289
87972
97331
132327
53913
79676
143110
79269
52366
62793
69437
97749
83596
147597
115883
82062
63800
61521
139314
127619
85790
132960
141289
86146
146104
128708
133054
116777
128402
85043
117344
107915
108669
108304
105300
75186
111352
112936
117177
93812
97737
61835
77529
145406
93489
75642
69806
109845
79133
60950
67797
111806
50597
50481
88338
102136
65377
55982
82754
68901
89232
63118
95534
98264
147706
80050
104953
146758
122884
122024
129236
113818
58099
134318
136312
75124
"""
