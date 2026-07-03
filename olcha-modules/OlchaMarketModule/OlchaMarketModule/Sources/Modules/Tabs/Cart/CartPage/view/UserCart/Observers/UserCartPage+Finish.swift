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
        
        orderSuccessed(paymentURL: data.0?.redirect_url,
                       shouldAutoRedirect: data.0?.auto == true)
        
        if let order = data.0 {
            MetricEvents.shared.purchaseEvent(observers, order)
        }
    }
    
    func successActions(paymentURL: String, showPaymentAction: Bool = true) {
        clearCart()
        
        var alertType: OrderSuccessAlertView.SuccessType = .history
        
        if showPaymentAction && paymentURL != "" {
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.coordinator?.pushPayment(paymentURL: paymentURL)
                }
                break
            case .history:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.coordinator?.pushMyOrdersList()
                }
                break
            default:
                break
            }
        })
    }
    
    func orderSuccessed(paymentURL: String? = nil, shouldAutoRedirect: Bool = false) {
        clearCartLocal()
        
        productsEmpty()
        
        let paymentURL = paymentURL ?? ""
        if shouldAutoRedirect && !paymentURL.isEmpty {
            clearCart()
            coordinator?.pushPayment(paymentURL: paymentURL)
        } else {
            successActions(paymentURL: paymentURL, showPaymentAction: false)
        }
        
        initialRequest()
        datasUpdated()
    }
}
