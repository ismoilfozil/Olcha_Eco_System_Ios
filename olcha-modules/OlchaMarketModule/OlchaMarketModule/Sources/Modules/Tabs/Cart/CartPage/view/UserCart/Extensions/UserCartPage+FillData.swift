//
//  CartPage+FillData.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/10/22.
//

import UIKit
extension UserCartPage {
    func productsUpdated() {
//        observers.addressSelected.send(true)
        observers.products.isEmpty ? enablePlaceholder() : disablePlaceholder()
//        observers.products.isEmpty ? animationView.play() : animationView.stop()
        
        if observers.products.isEmpty {
            table.setContentOffset(.zero, animated: false)
            productsEmpty()
        }
    }
    
    func bottomNavigationDatas() {
//        bottomProductsCount.text = "products".localized() + ":" + (observers.cart.getCost?.total_amount ?? 0).string
//        
//        let price = observers.cart.getCost?.total_cost ?? 0
//        
//        bottomPriceTitle.text = price.string.price
    }
    
    func checkButtonState(isGetCost: Bool) -> Bool {
        var isFilled = true
        
        if observers.products.isEmpty {
            isFilled = false
        }
        
        if observers.selectedAddress == nil {
            isFilled = false
        }
        
        if observers.selectedPayment == nil && !isGetCost {
            isFilled = false
        }
        
        if observers.selectedBuyType == nil || observers.selectedBuyType == BuyType.none {
            isFilled = false
        }
        
        if observers.shippingType == nil {
            isFilled = false
        }
        return isFilled
    }
}
