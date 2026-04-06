//
//  SearchViewController+Table.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 03/04/23.
//

import UIKit
import OlchaUI

extension SearchViewController: TableDelegates {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return providers.count
        default:
            return paging.footerLoadingCount()
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeue(PaymentTypeRoom.self, for: indexPath)
            if providers.isGreater(indexPath) {
                cell.setup(title: providers[indexPath.row].title_short,
                           image: providers[indexPath.row].logo?.logo)
                cell.checkState(isDisabled: providers[indexPath.row].isDisabled())
            }
            loadMoreProviders(indexPath.row)
            return cell
        default:
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            cell.responder.configureIndicator()
            return cell
        }
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard providers.isGreater(indexPath) else { return}
        coordinator?.pushProvider(provider: providers[indexPath.row])
    }
}
