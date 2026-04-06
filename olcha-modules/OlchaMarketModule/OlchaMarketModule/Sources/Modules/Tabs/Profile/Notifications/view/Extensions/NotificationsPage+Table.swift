//
//  NotificationsPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/10/22.
//

import UIKit
extension NotificationsPage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(NotificationRoom.self, for: indexPath)
        readNotification(index: indexPath.row)
        cell.setup(with: notifications[indexPath.row])
        
        cell.expandeButton.clicked {
            cell.isExpande = !cell.isExpande
            cell.expandeButton.rotate(degree: .pi)

            UIView.animate(withDuration: 0.2) {
                cell.contentView.layoutIfNeeded()
                tableView.performBatchUpdates(nil, completion: nil)
            }

        }
        
        return cell
    }
    
    
}
