//
//  ReturnOrderDTO.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 19/10/23.
//

import Foundation
import OlchaUI
public struct ReturnOrderModel {
    let dto: ReturnOrderDTO
    var orderID: Int?
}
public struct ReturnOrderDTO: Codable {

    var files: [Int]?
    var reason: String?
    var products: [ReturnOrderProductDTO]?
    
}

public struct ReturnOrderProductDTO: Codable {
    var store_id: Int?
    var id: Int?
    var amount: Int?
}
