//
//  ReturnOrderProducts+IO.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 18/10/23.
//

import UIKit
extension ReturnOrderProductsViewController {
    struct Input {
        var order: Order? {
            didSet {
                products = order?.products ?? []
            }
        }
        var products: [ProductModel] = []
    }
}
