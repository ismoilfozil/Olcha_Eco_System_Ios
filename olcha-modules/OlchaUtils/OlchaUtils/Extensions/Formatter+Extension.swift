//
//  Formatter+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/07/22.
//

import Foundation

public extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.init(identifier: "fr")
        formatter.maximumFractionDigits = 0
        formatter.groupingSeparator = " "
        return formatter
    }()
    
    static let originalWithSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.groupingSeparator = " "
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        formatter.decimalSeparator = "."
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
                
        return formatter
    }()
}
