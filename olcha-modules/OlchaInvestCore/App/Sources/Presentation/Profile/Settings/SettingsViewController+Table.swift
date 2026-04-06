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
        var tempRows: [SettingsRow] = [
            .language(language: "\(currentLanguage)"),
            .pushNotifications(isEnabled: false),
            .publicOffer(url: Texts.socialUrl.publicOffer),
            .about,
            .clearTooltipCache
        ]
        if Config.isTestFlightOrDebug {
            tempRows.append(.baseUrl(url: Texts.investUrl.base))
        }
        return tempRows
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SettingsTableCell.self, for: indexPath)
        cell.setup(with: rows[indexPath.row])
        switch rows[indexPath.row] {
        case .language(let language):
            cell.setRightLabel(language)
        case .pushNotifications(let isEnabled):
            cell.setSwitchValue(isOn: isEnabled)
            cell.setSwitchVisible()
        case .publicOffer, .about:
            cell.setIconVisible()
        case .baseUrl(let url):
            cell.setRightLabel(url.unwrap)
        case .clearTooltipCache:
            break
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch rows[indexPath.row] {
        case .language:
            pushLanguageViewController()
        case .pushNotifications: break
        case .publicOffer(let url):
            openURL(url)
        case .about:
            pushAboutViewController()
        case .baseUrl:
            Texts.investUrl.toogleBaseUrl()
        case .clearTooltipCache:
            clearTooltipCache()
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        tableView.reloadData()
    }
    
}
