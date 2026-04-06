//
//  OrderCancelRequest.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/12/22.
//

import Foundation
struct OrderCancelRequest: Codable {
    let id: Int
    let text: String
}
