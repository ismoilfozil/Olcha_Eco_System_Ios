//
//  PaymentsModalPage+Table.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 07/02/24.
//

import UIKit
import OlchaUI
extension PaymentsModalPage: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("uxrrrr", (observers?.checkBalanceEnough(payment: selectedPayment)))
        switch section {
        case 0:
            return allPayments.count
        default:

            return ((observers?.checkBalanceEnough(payment: selectedPayment) ?? 0) > 0) ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeue(PaymentRoom.self, for: indexPath)
            if allPayments.isGreater(indexPath) {
                let payment = allPayments[indexPath.row]
                cell.setup(title: payment.getName(),
                           imageURL: payment.logo ?? "",
                           subtitle: payment.getSubtitle())
                cell.isChosen = (payment == selectedPayment)
            }
            
            cell.separator.isHidden = (indexPath.row == allPayments.count-1)
            return cell
        default:
            let cell = tableView.dequeue(BalanceFillRoom.self, for: indexPath)
            
            cell.setup(observers: observers, selectedPayment: selectedPayment)
            cell.fillButton.settings.clicked { [weak self] in
                guard let self = self else { return }
                dismiss(animated: true)
                self.observers?.navigation.balanceFill.send()
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard allPayments.isGreater(indexPath) else { return }
        selectedPayment = allPayments[indexPath.row]
        tableView.reloadData()
    }
    
}
