//
//  BillingCurrencyData.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 07/08/23.
//

import Foundation
public struct BillingCurrencyData: Codable {
    
    public var rate: Double?
    public var round: String?
 
    public func getRate() -> Double {
        return rate ?? 0
    }
}


