//
//  PaymentsListViewController+Table.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 12/02/23.
//

import UIKit
import OlchaUI
extension ProvidersListViewController: TableDelegates {
    
    enum Section {
        case providers
        case loading
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
            case .providers:
                return skeleton.getCount(providers.count)
            case .loading:
                return paging.footerLoadingCount()
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .providers:
            let cell = tableView.dequeue(PaymentTypeRoom.self, for: indexPath)
            cell.configure(skeleton: skeleton)
            if providers.isGreater(indexPath) {
                cell.setup(title: providers[indexPath.row].title_short,
                           image: providers[indexPath.row].logo?.logo)
                cell.checkState(isDisabled: providers[indexPath.row].isDisabled())
                loadMore(indexPath.row)
            } else {
                cell.prepareForReuse()
            }
            
            return cell
        case .loading:
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            cell.responder.configureIndicator()
            return cell
        }
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.section == 0 {
            guard providers.isGreater(indexPath) else { return }
            coordinator?.pushProvider(provider: providers[indexPath.row])
        }
    }
}
