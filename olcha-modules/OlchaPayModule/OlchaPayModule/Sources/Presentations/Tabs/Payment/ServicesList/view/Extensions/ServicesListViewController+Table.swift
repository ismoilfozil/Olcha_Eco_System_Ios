//
//  ServicesListViewController+Tabl.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 27/03/23.
//

import UIKit
import OlchaUI

extension ServicesListViewController: TableDelegates {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        services.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PaymentTypeRoom.self, for: indexPath)
        if services.isGreater(indexPath) {
            cell.setup(title: services[indexPath.row].getTitle(),
                       image: provider?.logo?.logo)
            cell.checkState(isDisabled: services[indexPath.row].isDisabled())
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard services.isGreater(indexPath) else { return }
        coordinator?.pushMakeTransaction(
            makePaymentHelper: .init()
                               .addProvider(provider)
                               .addService(services[indexPath.row])
        )
    }
}
