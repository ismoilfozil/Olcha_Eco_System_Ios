//
//  ProductCell+States.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/11/22.
//

import UIKit
extension ProductCell {

    func leftBadgeState() {
        let discount = Funcs.calculateDiscount(product: self.product)
        if discount > 0 {
            discountContainer.isHidden = false
            discountLabel.text = "-" + discount.string + " %"
        } else {
            discountContainer.isHidden = true
        }
        
    }
    
    func calculateCreditText() {
        
        productPermonthPriceStack.isHidden = true
        withoutPercentTitle.isHidden = true
        productPermonthPrice.isHidden = true
        
        if let repayment = product?.monthly_repayment,
           let month_period = product?.plan?.max_period {
            productPermonthPrice.settings.textAlignment = .center
            productPermonthPriceStack.isHidden = false
            productPermonthPrice.isHidden = false
            productPermonthPrice.text = repayment.string.price + " x" + month_period
        }
        
        let month = Funcs.creditMonth(product: self.product)
        
        if month > 0 {
            productPermonthPriceStack.isHidden = false
            withoutPercentTitle.isHidden = false
            withoutPercentTitle.text = "0 | 0 | \(month)"
        }
        
    }
    
    
    func calculateOldPrice() {
        if Funcs.hasDiscount(product: product) {
            productOldPrice.attributedText = Funcs.getOldPrice(product: product).striked
            productOldPrice.isHidden = false
        } else {
            productOldPrice.text = ""
            productOldPrice.isHidden = true
        }
    }
    
    func checkCartButtonStack() {
        
        let outOfStock = product?.out_of_stock ?? false
        
        addCartButton.setup(with: product)
        
        if outOfStock {
            soldContainer.isHidden = false
            soldContainer.isUserInteractionEnabled = true
        } else {
            soldContainer.isHidden = true
            soldContainer.isUserInteractionEnabled = false
        }
    }

    func checkGiftExisting() {
        giftIcon.isHidden = (product?.gifts?.isEmpty ?? true)
    }
   
    func checkCashback() {
        let isCashbackEnabled = (product?.cashback_percent ?? 0) > 0
        cashback.setup(percent: product?.cashback_percent, hide: true)
        if isCashbackEnabled && Funcs.hasDiscount(product: product) {
            withoutPercentTitle.isHidden = true
        }
    }
}
