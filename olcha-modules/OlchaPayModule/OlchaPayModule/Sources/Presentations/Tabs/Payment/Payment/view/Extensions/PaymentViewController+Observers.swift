//
//  PaymentViewController+Observers.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 11/04/23.
//

import UIKit
import OlchaUtils
public extension PaymentViewController {
    
    func observerHelper() {
        paymentHelper.observers.selectedCard.sink { [weak self] isAction in
            guard let self = self, isAction else { return }
            navigationController?.dismissPresentedViewController()
            cardSelected()
        }.store(in: &bag)
        
        paymentHelper.observers.providerUpdated.sink { [weak self] isAction in
            guard let self = self, isAction else { return }
            providerUpdated()
        }.store(in: &bag)
        
        paymentHelper.observers.serviceUpdated.sink { [weak self] isAction in
            guard let self = self, isAction else { return }
            serviceUpdated()
        }.store(in: &bag)
        
        selectDefaultCardHelper.cardSelectedObserver = { [weak self] in
            guard let self = self else { return }
            cardSelected()
        }
    }
    
    func cardSelected() {
        cardSelectView.setup(card: paymentHelper.selectedCard)
        setupAmountRules()
        checkButtonState()
    }
    
    func providerUpdated() {
        navigationBar.setTitle(paymentHelper.provider?.title_short)
//        guard paymentHelper.service == nil else {
//            paymentHelper.observers.serviceUpdated.send(true)
//            return
//        }
        paymentHelper.service = paymentHelper.provider?.service?.first(where: { $0.id == paymentHelper.serviceID } )
        
        paymentHelper.observers.serviceUpdated.send(true)
    }
    
    func serviceUpdated() {
        createFields()
        checkValues()
    }
    
}
