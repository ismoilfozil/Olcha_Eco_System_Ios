//
//  ProductModel+Array+Extension.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 22/01/24.
//

import Foundation
extension Array where Element: ProductModel {
    
    func changeCartCount(cartItem: CartItem?, completion: (() -> Void)?) {
        guard let cartItem else { return }
        DispatchQueue.global(qos: .utility).async {
            for value in self {
                if value.id == cartItem.product_id && value.getStoreID() == cartItem.store_id {
                    value.cart_count = cartItem.quantity
                }
            }
            completion?()
        }
    }
    
    mutating func cartChanged(cartItem: CartItem?) {
        guard let cartItem else { return }
        if cartItem.quantity == 0 {
            if let index = self.firstIndex(where: { $0.id == cartItem.product_id && $0.getStoreID() == cartItem.store_id } ) {
                self.remove(at: index)
            }
        }
    }
}
