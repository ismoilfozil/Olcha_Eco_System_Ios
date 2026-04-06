//
//  CartPage+Finish.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 19/01/24.
//

import OlchaUI
import UIKit

extension UserCartPage {
    func orderFinished(data: (CheckoutOrdered?, GetCostRequest)) {
        
        let request = data.1
        
        orderSuccessed(paymentURL: data.0?.redirect_url)
        
        if let order = data.0 {
            MetricEvents.shared.purchaseEvent(observers, order)
        }
    }
    
    func successActions(paymentURL: String) {
        clearCart()
        
        var alertType: OrderSuccessAlertView.SuccessType = .history
        
        if paymentURL != "" {
            alertType = .payment
        }
        
        showOrderSuccess(type: alertType,
                         homeObserver: { [weak self] in
            guard let self = self else { return }
            self.tabBarController?.selectedIndex = OlchaTab.home
        }, actionObserver: { [weak self] in
            guard let self = self else { return }
            switch alertType {
            case .payment:
                self.coordinator?.pushPayment(paymentURL: paymentURL)
                break
            case .history:
                self.coordinator?.pushMyOrdersList()
                break
            default:
                break
            }
        })
    }
    
    func orderSuccessed(paymentURL: String? = nil) {
        clearCartLocal()
        
        productsEmpty()
        successActions(paymentURL: paymentURL ?? "")
        
        initialRequest()
        datasUpdated()
    }
}
