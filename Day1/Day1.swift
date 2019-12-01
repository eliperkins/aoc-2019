//
//  Day1.swift
//  Day1
//
//  Created by Eli Perkins on 12/1/19.
//  Copyright © 2019 eliperkins. All rights reserved.
//

import Foundation

public func calculateFuel(for mass: Int) -> Int {
    return Int(floor(Double(mass) / 3) - 2)
}

public func calculateFuelAccountingForAdditionalMass(for mass: Int) -> Int {
    let fuel = calculateFuel(for: mass)
    if fuel <= 0 {
        return 0
    } else {
        return fuel + calculateFuelAccountingForAdditionalMass(for: fuel)
    }
}
