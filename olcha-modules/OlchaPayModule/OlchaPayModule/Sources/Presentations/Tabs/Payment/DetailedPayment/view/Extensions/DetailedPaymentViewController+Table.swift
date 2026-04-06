//
//  DetailedTransactionViewController+Table.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 23/02/23.
//

import UIKit
import OlchaUI
extension DetailedTransactionViewController: TableDelegates {
    public enum Section {
        case header
        case details
        case actions
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .header:
            return 1
        case .details:
            return details.count
        case .actions:
            return 2
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .header:
            let cell = tableView.dequeue(PayedHeaderRoom.self, for: indexPath)
            cell.setup(with: transaction)
            return cell
        case .details:
            let cell = tableView.dequeue(PayedDetailRoom.self, for: indexPath)
            cell.setup(with: details[indexPath.row])
            return cell
        case .actions:
            if indexPath.row == 0 {
                let cell = tableView.dequeue(FooterItem.self, for: indexPath)
                cell.responder.height = 16
                cell.responder.withSeparator = false
                return cell
            } else {
                let cell = tableView.dequeue(FinishActionsRoom.self, for: indexPath)
                
                cell.responder.retryButton.clicked { [weak self] in
                    guard let self = self else { return }
                    self.showRetryTransaction {
                        self.retryTransaction()
                    }
                }
                
                cell.responder.saveButton.clicked { [weak self] in
                    guard let self = self else { return }
                    self.checkSaveTransaction()
                }
                
                cell.responder.detailButton.clicked { [weak self] in
                    guard let self = self else { return }
                    self.createPdf()
                }
                return cell
            }
        }
    }
    
    private func createPdf() {
        coordinator?.pushInvoice(transaction: transaction)
    }
    
    private func checkSaveTransaction() {
        getTransaction { [weak self] model in
            guard let self, let fullTransaction = self.fullTransaction else { return }
            print("save transaction n n n n n n n", model, fullTransaction)
            self.coordinator?.pushSaveTransaction(transaction: fullTransaction)
        }
    }
    
    private func retryTransaction() {
        getTransaction { [weak self] model in
            guard let self = self,
                  let fullTransaction = self.fullTransaction else { return }
            self.coordinator?.pushMakeTransaction(detailedTransaction: fullTransaction)
        }
    }
    
}
