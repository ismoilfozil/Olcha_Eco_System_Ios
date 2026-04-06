//
//  BillingPaymentViewController+State.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 05/07/23.
//

import Foundation
extension BillingPaymentViewController {
    
    public func payButtonClicked() {
        switch (input.billingFilter.payment.paymentState, input.billingFilter.payment.otpState) {
        
        case (.webhook, _):
            payWebhook()
        case (.balance, _):
            payBalance()
        case (.bankCard, .default):
            sendOtp()
        case (.bankCard, .otp):
            payBankCards()
        default:
            break
        }
    }
    
    public func payBalance() {
        viewModel.sendOtp(filter: input.billingFilter)
    }
    
    public func payWebhook() {
        viewModel.payWebhook(filter: input.billingFilter)
    }
    
    public func sendOtp() {
        viewModel.sendOtp(filter: input.billingFilter)
    }
    
    public func payBankCards() {
        input.billingFilter.payment.otpState = .payment
        input.billingFilter.set(otp: otpField.getValue())
        viewModel.payBankCard(filter: input.billingFilter)
    }
    
    public func loadPaymentTypes() {
        loadWebhooks()
        loadBankCards()
        loadBalances()
    }
    
    public func loadBankCards() {
        viewModel.loadBankCards(filter: input.billingFilter)
    }
    
    public func loadBalances() {
        viewModel.loadBalances(filter: input.billingFilter)
    }
    
    public func loadWebhooks() {
        viewModel.loadPaymentTypes(filter: input.billingFilter)
    }
    
    public func checkErrorMessage(_ message: String? = nil) {
        if let message {
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = message
        } else {
            errorMessageLabel.isHidden = true
        }
    }
}
