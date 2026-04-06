//
//  Double+extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/07/22.
//

import Foundation
public extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
    
    var int: Int {
        Int(self)
    }
    
    var date: Date? {
        Date(timeIntervalSince1970: self)
    }
}
