//
//  BillingPaymentViewController+Observers.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 05/07/23.
//

import UIKit
import Combine
import OlchaUI

public extension BillingPaymentViewController {
    func setupPaymentObservers() {
        
        handle(viewModel.$webhookPayment,
               withError: false,
               success: { [weak self] data in
            guard let self = self else { return }
            openURL(data?.getUrl())
        }, failure: { [weak self] error in
            guard let self = self else { return }
            checkErrorMessage(error?.message)
        }, loading: { [weak self] isLoading in
            guard let self = self else { return }
            payButton.settings.requesting = isLoading
        })
        
        handle(viewModel.$otpPayment,
               withError: false,
               success: { [weak self] data in
            guard let self = self else { return }
            if (data?.withOtp() ?? false) {
                input.billingFilter.set(transaction_id: data?.transaction_id?.string)
                input.billingFilter.payment.otpState = .otp
                checkButtonState()
                otpFieldChanged()
            } else {
                coordinator?.pushSuccess()
            }
        }, failure: { [weak self] error in
            guard let self = self else { return }
            checkErrorMessage(error?.message)
        }, loading: { [weak self] isLoading in
            guard let self = self else { return }
            payButton.settings.requesting = isLoading
        })
        
        handle(viewModel.$bankCardPayment,
               withError: false,
               success: { [weak self] data in
            guard let self = self else { return }
            coordinator?.pushSuccess()
        }, failure: { [weak self] error in
            guard let self = self  else { return }
            input.billingFilter.payment.otpState = .otp
            checkErrorMessage(error?.message)
        }, loading: { [weak self] isLoading in
            guard let self = self else { return }
            payButton.settings.requesting = isLoading
        })
        
        handle(viewModel.$currency,
               success: { [weak self] data in
            guard let self = self else { return }
            input.currency = data
            setupCurrency()
        })
        
        output.loadCards.sink { [weak self] canLoad in
            guard let self = self,
                  canLoad else { return }
            loadBankCards()
        }.store(in: &bag)
        
        output.addCardObserver.sink { [weak self] bankCardParent in
            guard let self = self else { return }
            coordinator?.presentAddBankCard(
                filter: .init()
                        .set(payment_alias: bankCardParent.alias),
                loadCards: output.loadCards
            )
        }.store(in: &bag)
    }
}
