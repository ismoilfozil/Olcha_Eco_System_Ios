//
//  MyInstallmentViewController+Table.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 17/05/23.
//

import UIKit
import OlchaUI
extension MyInstallmentViewController: TableDelegates {
    public enum SegmentState {
        case graph
        case detailed
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch output.currentState {
        case .graph:
            return input.skeleton.getCount(input.monthlyPayments.count)
        case .detailed:
            return input.skeleton.getCount(input.details.count)
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch output.currentState {
        case .graph:
            let cell = tableView.dequeue(InstallmentGraphRoom.self, for: indexPath)
            cell.configure(skeleton: input.skeleton)
            if input.monthlyPayments.isGreater(indexPath) {
                cell.setup(with: input.monthlyPayments[indexPath.row])
                cell.expandeButton.clicked { [weak self] in
                    guard let self = self else { return }
                    input.monthlyPayments[indexPath.row].isExpanded = !input.monthlyPayments[indexPath.row].isExpanded
                    tableView.reloadData()
                }
            }
            return cell
        case .detailed:
            let cell = tableView.dequeue(InstallmentDetailRoom.self, for: indexPath)
            cell.configure(skeleton: input.skeleton)
            if input.details.isGreater(indexPath) {
                cell.setup(title: input.details[indexPath.row].title,
                           content: input.details[indexPath.row].key)
            }
            return cell
        }
    }
    
}
