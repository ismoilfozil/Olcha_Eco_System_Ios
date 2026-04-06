//
//  MyOrdersPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 17/10/22.
//

import UIKit
import OlchaUI
extension MyOrdersPage: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .empty:
            return 1
        case .order:
            return orders.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard sections.isGreater(indexPath.section) else { return UITableViewCell() }
        switch sections[indexPath.section] {
        case .empty:
            let cell = tableView.dequeue(EmptyPlaceholderRoom.self, for: indexPath)
            cell.setTitle(text: "order_empty_placeholder".localized())
            return cell
        case .order:
            let cell = tableView.dequeue(MyOrderRoom.self, for: indexPath)
            cell.tableReloader = tableReloader
            if orders.isGreater(indexPath) {
                cell.setup(with: orders[indexPath.row])
            }
            cell.cancelButton.clicked { [weak self] in
                guard let self, orders.isGreater(indexPath) else { return }
                cancel(order: orders[indexPath.row])
            }
            cell.statusView.settings.clicked { [weak self] in
                guard let self, orders.isGreater(indexPath) else { return }
                let order = orders[indexPath.row]
                coordinator?.presentOrdersStep(steps: order.getHistories() )
            }
            cell.deliveryCodeButton.clicked { [weak self] in
                guard let self, orders.isGreater(indexPath) else { return }
                let order = orders[indexPath.row]
                if let code = order.delivery_code {
                    coordinator?.presentDeliveryCode(code: code, orderId: order.id)
                }
            }
            loadMore(index: indexPath.row)
            return cell
        }
    }
    
    
    func cancel( order: Order? ) {
        guard let id = order?.id else { return }
        coordinator?.presentCancelCause { [weak self] cause in
            guard let self = self else { return }
            self.viewModel.cancelOrder(id: id, cause: cause)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if orders.isGreater(indexPath) {
            coordinator?.pushOrder(order: orders[indexPath.row])
        }
    }
    
}
