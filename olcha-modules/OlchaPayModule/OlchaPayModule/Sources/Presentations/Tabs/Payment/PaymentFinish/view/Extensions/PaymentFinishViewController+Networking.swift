//
//  PaymentFinishViewController+Networking.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 07/04/23.
//

import UIKit
extension PaymentFinishViewController {
    
    func createPdf() {
        coordinator?.pushInvoice(transaction: transaction)
    }
    
    func checkSaveTransaction() {
        getTransaction { [weak self] model in
            guard let self = self,
                  let fullTransaction = self.fullTransaction else { return }
            self.coordinator?.pushSaveTransaction(transaction: fullTransaction)
        }
    }

    func retryTransaction() {
        getTransaction { [weak self] model in
            guard let self = self,
                  let fullTransaction = self.fullTransaction else { return }
            self.coordinator?.pushMakeTransaction(detailedTransaction: fullTransaction)
        }
    }
}
