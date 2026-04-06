//
//  SettingsViewController+Table.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 31/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaUtils

extension SettingsViewController: TableDelegates {
    
    public var rows: [SettingsRow] {
        let currentLanguage = LanguageRow(rawValue: String.getAppLanguage())?.title ?? ""
        let isNotificationEnabled = CommonGlobalDefaults.settings.pushNotificationsEnabled.orFalse
        return [
            .language(lang: currentLanguage),
            .pushNotifications(isEnabled: isNotificationEnabled),
            .publicOffer(url: Texts.socialUrl.publicOffer),
        ]
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SettingsTableCell.self, for: indexPath)
        cell.setup(with: rows[indexPath.row])
        switch rows[indexPath.row] {
        case .language(let lang):
            cell.setRightLabel(lang)
        case .pushNotifications(let isEnabled):
            cell.setSwitchValue(isOn: isEnabled)
            cell.setSwitchVisible()
            cell.switchValueObserver = { [weak self] isEnabled in
                guard let self else { return }
                CommonGlobalDefaults.settings.pushNotificationsEnabled = isEnabled
            }
        case .publicOffer:
            cell.setIconVisible()
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch rows[indexPath.row] {
        case .language:
            pushLanguageViewController()
        case .pushNotifications:
            CommonGlobalDefaults.settings.pushNotificationsEnabled?.toggle()
        case .publicOffer(let url):
            openSafari(urlString: url)
        }
        tableView.reloadData()
    }
    
}
