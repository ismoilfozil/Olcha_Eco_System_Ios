//
//  NotificationsViewController+Table.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 15/02/23.
//

import UIKit
import OlchaUI

extension NotificationsViewController: TableDelegates {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return notifications.count
        default:
            return paging.footerLoadingCount()
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notification = notifications[indexPath.row]
        let lastNotification = getLastNotification(indexPath)
        let cell = tableView.dequeue(NotificationRoom.self, for: indexPath)
        cell.setup(with: notification, oldData: lastNotification)
        cell.moreButton.clicked { [weak self] in
            guard let self = self else { return }
            self.viewModel.readNotification(notification: notification)
            notification.isRead = true
            
            cell.setup(with: notification, oldData: lastNotification)
            
            self.coordinator?.pushDetailedNotification(notification)
        }
        return cell
    }
    
    private func getLastNotification(_ indexPath: IndexPath) -> NotificationModel? {
        let index = indexPath.row - 1
        
        guard index >= 0, index < notifications.count else {
            return nil
        }
        
        let notification = notifications[index]
        return notification
    }
}
