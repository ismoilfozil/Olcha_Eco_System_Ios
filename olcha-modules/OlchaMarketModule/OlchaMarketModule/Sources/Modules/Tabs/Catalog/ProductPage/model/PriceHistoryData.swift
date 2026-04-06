//
//  PriceHistoryData.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/08/22.
//

import Foundation
public struct PriceHistoryData: Codable {
    var priceHistory: [PriceHistory]?
}

public struct PriceHistory: Codable {
    var price: Int
    var date: String?
}
