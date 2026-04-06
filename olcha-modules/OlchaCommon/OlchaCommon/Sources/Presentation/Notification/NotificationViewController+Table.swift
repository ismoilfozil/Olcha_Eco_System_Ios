//
//  Notification+Table.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 30/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaUtils

extension NotificationViewController: TableDelegates {
    
    public enum Section: CaseIterable {
        case notification
    }
    
    public var sections: [Section] {
        [.notification]
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return input.notifications.modelsCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(NotificationTableCell.self, for: indexPath)
        cell.setup(with: input.notifications.models[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowData = input.notifications.models[indexPath.row]
        guard let action = rowData.click_action?.getAction() else {
            return
        }
        if let commonAction = checkClickAction(action) {
            switch commonAction {
            case .text:
                if input.notifications.models.isGreater(indexPath) {
                    pushDetailView(model: input.notifications.models[indexPath.row])
                }
            }
        } else {
            selectObserver?(action)
        }
    }
    
    private func checkClickAction(_ action: ClickAction) -> CommonClickAction? {
        action as? CommonClickAction
    }
    
    private func pushDetailView(model: CommonNotificationModel) {
        let vc: NotificationDetailViewController = CommonDIContainer.shared.resolve()
        vc.notification = model
        navigationController?.push(vc)
    }
    
}
