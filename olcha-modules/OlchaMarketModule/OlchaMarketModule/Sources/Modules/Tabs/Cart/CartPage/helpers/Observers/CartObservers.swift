//
//  CartObservers.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/09/22.
//

import Foundation
import Combine
import OlchaUtils
import OlchaUI
import OlchaAuth

public final class CartObservers {
    
    
    let navigation = CartNavigateObservers()
    let action = CartActionObservers()
    let skeleton = CartSkeletonObservers()
    
    
    var isVerified: Bool = false
    var isBonusUsing: Bool = false
    
    var products: [ProductModel] = [] 
    var locations: [UserAddress] = [] {
        didSet {
            if let address = selectedAddress, !locations.contains(address) {
                selectedAddress = nil
            }
        }
    }
    var limitBalance: Balance?
    var shippingTypes: [Delivery] = []
    var name: String?
    var phone: String?
    var paymentTypes: PaymentTypeData?
    var getCost: GetCostData?
    var bonus: Bonus?
    var selectedAddress: UserAddress?
    var shippingType: Delivery?
    var selectedPayment: Payments?
    var selectedBuyType: BuyType?
    var comment: String?
    var coupon: Coupon?
    var credit: CreditOrder?
    var temporaryCredit: CreditOrder?
    var resetCoupon: Bool = false
    
    var errorlyChecked: Bool = false
 
    func reset() {
        
        bonus = nil
        getCost = nil
        
        selectedAddress = nil
        shippingType = nil
        selectedPayment = nil
        selectedBuyType = nil
        comment = nil
        coupon = nil
        credit = nil
        paymentTypes = nil
        temporaryCredit = nil
        shippingTypes = []
        resetCoupon = true
        errorlyChecked = false
        
        action.tableReloader.send()
    }
    func reorderLocations() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            if let index = self.locations.firstIndex(where: { $0 == self.selectedAddress }) {
                self.locations.swapAt(0, index)
            }
        }
    }
    
    func isAllProductsSelected() -> Bool {
        guard !products.isEmpty else { return false }
        return products.allSatisfy { $0.cartSelected == true }
    }
    
}


extension CartObservers {
    func appendProducts(_ data: [ProductModel], completion: (() -> Void)?) {
        products = data
//        for element in data {
//            if !products.contains(element) {
//                products.append(element)
//            }
//        }
        completion?()
    }
    
    func appendLocations(_ data: [UserAddress]) {
        self.locations = data
        if selectedAddress == nil {
            if let mainAddress = locations.first(where: { $0.isMainAddress() }) {
                self.selectedAddress = mainAddress
            } else {
                self.selectedAddress = locations.first
            }
            action.addressSelected.send()
        }
        
        reorderLocations()
    }
}
// MARK: Getters
extension CartObservers {
    func getName() -> String {
        return (name ?? AuthGlobalDefaults.user.name) ?? "-"
    }
    
    func getPhone() -> String {
        return (phone ?? AuthGlobalDefaults.user.phone) ?? "-"
    }
    
    func isLimitActive() -> Bool {
        guard let limitBalance else { return true }
        guard let amount = limitBalance.amount, amount > 0 else { return false }
        guard amount > (getTotalPrice() * 0.1) else { return false }
        return true
    }
    
    func getTotalPrice() -> Double {
        products.map { $0.total_price?.double ?? 0 }.reduce(0.0, +)
    }
    
}

//MARK: Validations
extension CartObservers {
    func checkBalanceEnough(payment: Payments?) -> Double {
        guard let balance = payment?.balance else { return 0.0 }
        let amount = balance.getAmount().double
        
        if getCost == nil {
            return getTotalPrice() - amount
        } else {
            if selectedBuyType == .cash {
                let totalCost = getCost?.total_cost?.double ?? 0
                return totalCost - amount
            } else {
                let firstFee = credit?.creditDatas[credit?.creditType ?? .olcha]?.first_fee_sum.double ?? 0
                return firstFee - amount
            }
        }
    }
}
