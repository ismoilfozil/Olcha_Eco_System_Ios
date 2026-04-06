//
//  OrderCancelPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/12/22.
//

import UIKit
import OlchaUI
extension OrderCancelPage: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .statics:
            return items.count
        case .comment:
            return (selectedItem == .other) ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .statics:
            let item = items[indexPath.row]
            let cell = tableView.dequeue(CancelCauseRoom.self, for: indexPath)
            cell.isChecked = (selectedItem == item)
            cell.setup(with: item.title)
            return cell
        case .comment:
            let cell = tableView.dequeue(CommentRoom.self, for: indexPath)
            cell.initialComment = comment
            cell.commentObserver = commentObserver
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch sections[indexPath.section] {
        case .statics:
            selectedItem = items[indexPath.row]
            tableView.reloadData()
            checkButtonState()
        case .comment: break
        }
    }
}
