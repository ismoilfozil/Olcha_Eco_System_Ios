//
//  CreditStoreRoom+Types.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 11/11/22.
//

import UIKit
extension OlchaCreditStoreRoom {
    func setupObservers() {
        viewModel
            .$minInitialPayment
            .sink { [weak self] data in
                guard let self = self else { return }
                self.hintInfoTitle.text = "initial_pay".localized() + " " + data.int.string.price
            }.store(in: &bag)
        
        viewModel
            .$allPayment
            .sink { [weak self] data in
                guard let self = self else { return }
                self.overallLabel?.text = data.int.string.price
            }.store(in: &bag)
        
        viewModel
            .$monthPayment
            .sink { [weak self] data in
                guard let self = self else { return }
                self.permonthLabel?.text = data.int.string.price
            }.store(in: &bag)
        
        firstPaymentField.observeText { [weak self] in
            guard let self = self else { return }
            let text = self.firstPaymentField.getPrice()
            
            var payment = text.double
            self.errorLabel.isHidden = true
            
            if payment > self.viewModel.maxInitialPayment {
                payment = self.viewModel.maxInitialPayment
                self.firstPaymentField.settings.text = payment.int.string.priceWithoutCurrency
                self.viewModel.initialPayment = payment
                self.viewModel.calculate(products: self.products)
                
                self.updateData()
                self.isReady?.send(true)
                
            } else if payment < self.viewModel.minInitialPayment {
                self.errorLabel.isHidden = false
                self.errorLabel.text = "initial_pay".localized() + " " + self.viewModel.minInitialPayment.int.string.price
                self.isReady?.send(false)
            } else {
                self.viewModel.initialPayment = payment
                self.viewModel.calculate(products: self.products)
                
                self.updateData()
                self.isReady?.send(true)
            }
            contentView.layoutIfNeeded()
        }
        
        viewModel.$productsMonthlyPayments
            .sink { [weak self] data in
                guard let self else { return }
                graphObserver?.send(data)
                updateEmbeddedGraph(with: data)
            }.store(in: &bag)
    }
}
