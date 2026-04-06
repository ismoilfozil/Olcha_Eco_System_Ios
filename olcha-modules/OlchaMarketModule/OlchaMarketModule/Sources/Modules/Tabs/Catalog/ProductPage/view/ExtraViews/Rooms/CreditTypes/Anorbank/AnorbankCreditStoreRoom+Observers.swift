//
//  AnorbankCreditStoreRoom+Observers.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 11/11/22.
//

import Foundation
extension AnorbankCreditStoreRoom {
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
        
    }
}
