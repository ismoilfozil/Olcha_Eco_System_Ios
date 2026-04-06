//
//  InstallmentSortModal+Table.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 17/06/23.
//

import UIKit
import OlchaUI
extension InstallmentSortModal: TableDelegates {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output.copiedFilters.allStatuses.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(InstallmentStatusRoom.self, for: indexPath)
        cell.isChosen = (output.copiedFilters.allStatuses[indexPath.row].key == output.copiedFilters.status.key)
        cell.setup(status: output.copiedFilters.allStatuses[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        output.copiedFilters.status = output.copiedFilters.allStatuses[indexPath.row]
        tableView.reloadData()
    }
}
