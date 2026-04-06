//
//  OrderPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 21/10/22.
//

import UIKit
extension OrderPage: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        switch section {
        case .data:
            return orderDataModels.count
        case .products:
            return order?.products?.count ?? 0
        case .anorbankVerify:
            return anorbankVerifyCount()
        case .pay:
            return isAnorbank() ? 0 : payButtonCount()
        case .payments:
            return isAnorbank() ? 0 : paymentsCount()
        case .payAll:
            return isAnorbank() ? 0 : paymentsCount()
        case .graph:
            return isAnorbank() ? 0 : graphCount()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .data:
            let cell = tableView.dequeue(OrderDataRoom.self, for: indexPath)
            cell.setup(with: orderDataModels[indexPath.row])
            
            return cell
        case .products:
            let cell = tableView.dequeue(OrderPaymentProductRoom.self, for: indexPath)
            cell.setup(with: order?.products?[indexPath.row],
                       date: order?.created_at?.month)
            
            cell.reviewButton.clicked { [weak self] in
                guard let self = self else { return }
                self.coordinator?.pushAddReview(product: self.order?.products?[indexPath.row])
            }
            
            cell.checkButton.clicked { [weak self] in
                guard let self = self,
                      let url = order?.products?[indexPath.row].qrcode else { return }
                self.coordinator?.pushWebCheck(urlString: url)
            }
            
            cell.isOpened = isOpenedProducts[indexPath] ?? false
            
            cell.bottomSection.moreButton.clicked { [weak self] in
                guard let self else { return }
                isOpenedProducts[indexPath] = !(isOpenedProducts[indexPath] ?? false)
                tableView.reloadData()
            }
            return cell
        case .anorbankVerify:
            let cell = tableView.dequeue(AnorbankVerifyRoom.self, for: indexPath)
            cell.verifyButton.settings.clicked { [weak self] in
                guard let self = self else { return }
                self.coordinator?.anorbankVerify(verifyObserver: self.verifyObserver, orderID: self.order?.id)
            }
            return cell
        case .pay:
            let cell = tableView.dequeue(OrderPayRoom.self, for: indexPath)
            cell.payButton.settings.clicked { [weak self] in
                guard let self = self else { return }
                self.orderViewModel.loadOrderPaymentURL(orderID: self.order?.id)
            }
            
            orderViewModel
                .paymentURLRequesting
                .sink { isLoading in
                    cell.payButton.settings.requesting = isLoading
                }.store(in: &bag)
            
            return cell
        case .payments:
            let cell = tableView.dequeue(OrderPaymentsRoom.self, for: indexPath)
            cell.observer = observer
            cell.setup(payments: payments, bankCards: bankCards, balance: balance)
            return cell
        case .payAll:
            let cell = tableView.dequeue(PayAllRoom.self, for: indexPath)
            
            cell.observer = observer
            
            cell.payButton.clicked({ [weak self] in
                guard let self else { return }
                payClicked()
            }, disableListener: { [weak self] in
                guard let self else { return }
                payButtonDisableError()
            })
                
            orderViewModel
                .paymentURLRequesting
                .sink { isLoading in
                    cell.payButton.settings.requesting = isLoading
                }.store(in: &bag)
            
            return cell
        case .graph:
            if indexPath.row == 0 {
                let cell = tableView.dequeue(ComponentHeader.self, for: indexPath)
                cell.configure(with: .title("fire_plan".localized()))
                return cell
            } else {
                let cell = tableView.dequeue(PaymentGraphRoom.self, for: indexPath)
                cell.setup(with: creditGraphPayments[indexPath.row - 1])
                
                cell.dateButton.clicked { [weak self] in
                    guard let self = self else { return }
                    cell.isExpande = !cell.isExpande
                    self.creditGraphPayments[indexPath.row - 1].isExpanded = cell.isExpande
                    tableView.reloadData()
                }
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch sections[indexPath.section] {
        case .products:
            if (order?.products?.isGreater(indexPath) ?? false) {
                productHelper.pushProduct.send(order?.products?[indexPath.row])
            }
            break
        default: break
        }
    }
    
    private func payButtonCount() -> Int {
        (order?.checkOrderPayButtonStatus() ?? false) ? 1 : 0
    }
    
    private func paymentsCount() -> Int {
        (order?.checkInstallmentPayButtonStatus() ?? false) ? 1 : 0
    }
    
    private func graphCount() -> Int {
        guard let order = order else { return 0 }
        if (order.is_installment ?? false) {
            let status = order.getStatus()
            let installmentStatus = order.getInstallmentStatus()
            if (status == .in_work || status == .pending || status == .finished) && installmentStatus != .canceled && installmentStatus != .fail {
                return creditGraphPayments.isEmpty ? 0 : (creditGraphPayments.count + 1)
            }
        }
        return 0
    }
    
    private func anorbankVerifyCount() -> Int {
        return 0
        return (!hasAnorbank() && order?.getPaymentType() == .anorbank_instalment && order?.getStatus() != .canceled) ? 1 : 0
    }
    
    private func hasAnorbank() -> Bool {
        return (order?.has_anorbank_transaction ?? false)
    }
    
    private func isAnorbank() -> Bool {
        order?.getPaymentType() == .anorbank_instalment
    }
    
    private func payButtonDisableError() {
        showToast(text: "payment_type_select_error".localized())
    }
}
