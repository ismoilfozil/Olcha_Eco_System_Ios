//
//  MyInstallmentsViewController+Table.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 15/05/23.
//

import UIKit
import OlchaCore
import OlchaUI

extension MyInstallmentsViewController: TableDelegates {
    public func numberOfSections(in tableView: UITableView) -> Int {
        table.baseSections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch table.baseSections[section] {
        case .models:
            return input.skeleton.getCount(getModels().count)
        case .indicator:
            return getPaging().footerLoadingCount()
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch table.baseSections[indexPath.section] {
        case .models:
            let cell = tableView.dequeue(InstallmentRoom.self, for: indexPath)
            cell.configure(skeleton: input.skeleton)
            if getModels().isGreater(indexPath) {
                cell.setup(with: getModels()[indexPath.row])
                cell.moreButton.settings.clicked { [weak self] in
                    guard let self = self else { return }
                    coordinator?.pushInstallment(installment: getModels()[indexPath.row], shouldPay: false)
                }
                loadMore(indexPath.row)
            } else {
                cell.prepareForReuse()
            }
            return cell
        case .indicator:
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            cell.responder.configureIndicator()
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard table.baseSections[indexPath.section] == .models, getModels().isGreater(indexPath) else { return }
        coordinator?.pushInstallment(installment: getModels()[indexPath.row], shouldPay: false)
    }
    
    public func getModels() -> [InstallmentModel] {
        output.filters.installments.models
    }
    
    public func getPaging() -> Paging {
        output.filters.installments.paging
    }
    
    
}
