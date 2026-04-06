//
//  PaymentViewController+Networking.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 10/04/23.
//

import UIKit
import OlchaUtils
public extension PaymentViewController {
    func makeTransaction() {
        
        let filledFields = fields
            .map { TransactionKeyValueModel(key: $0.getKey(),
                                            value: $0.getValue(),
                                            is_money: mainFieldKeys.contains($0.getServiceType() ?? .none) ? true : false,
                                            type: $0.getType())
            }
        
        paymentHelper.fields = filledFields
        
        makeTransactionViewModel.makeTransaction(helper: paymentHelper)
    }
    
    func loadInitialProvider() {
//        paymentHelper.observers.providerUpdated.send(true)
        guard let serviceID = paymentHelper.serviceID else {
            return
        }
        
//      paymentHelper.provider == nil else {
//      paymentHelper.observers.providerUpdated.send(true)
//      return
//  }
        paymentsViewModel.loadProvider(serviceID: serviceID)
    }
    
    func networkObservers() {
        handle(makeTransactionViewModel.$makeTransaction) { [weak self] data in
            guard let self = self else { return }
            coordinator?.pushVerifyPayment(verifyData: data, makePaymentHelper: paymentHelper)
        } loading: { [weak self] isLoading in
            guard let self = self else { return }
            self.acceptButton.settings.requesting = isLoading
        }
        
        handle(paymentsViewModel.$provider,
               showLoader: true,
               success: { [weak self] data in
            guard let self = self else { return }
            self.paymentHelper.provider = data?.providers
            paymentHelper.observers.providerUpdated.send(true)
        })
        
    }
    
}
