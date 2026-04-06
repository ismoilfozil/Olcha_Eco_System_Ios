//
//  PaymentsGroup+Table.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 11/02/23.
//

import OlchaUI
import UIKit
extension PaymentsGroupViewController: TableDelegates {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PaymentGroupRoom.self, for: indexPath)
        cell.responder.setupHeader(title: "Связь")
        cell.responder.observer = observerHelper
        cell.withBorder = true
        cell.setup()
        cell.responder.header.seeAllClicked { [weak self] in
            guard let self = self else { return }
//            self.coordinator?.pushPaymentType()
        }
        return cell
    }
}
