//
//  BasketStorageViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/07/22.
//

import Foundation
class BasketStorageViewModel {
    func getStoreProduct(storeID: Int, productID: Int, basketModels: [BasketModelData]) -> Int {
        let product = basketModels.filter { $0.store_id == storeID && $0.product_id == productID }
        return product.count
    }
}
