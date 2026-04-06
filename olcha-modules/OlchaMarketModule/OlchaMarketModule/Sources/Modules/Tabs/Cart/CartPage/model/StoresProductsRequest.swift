//
//  StoresProductsRequest.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 29/09/22.
//

import Foundation
struct StoresProductsRequest : Codable {
    var products: [CartItem]?
}
