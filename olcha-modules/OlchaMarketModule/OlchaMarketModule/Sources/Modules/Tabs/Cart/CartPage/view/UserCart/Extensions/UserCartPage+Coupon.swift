//
//  CartPage+Coupon.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/03/23.
//

import Foundation
extension UserCartPage {
    func cancelCoupon() {
        observers.coupon = nil
    }
    
    func checkCoupon(_ couponString: String) {
        viewModels.checkout.checkCoupon(coupon: couponString)
    }
}
