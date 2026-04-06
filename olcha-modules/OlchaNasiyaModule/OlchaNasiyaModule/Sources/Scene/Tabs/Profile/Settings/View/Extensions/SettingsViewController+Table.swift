//
//  SettingsViewController+Table.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 23/05/23.
//

import UIKit
import OlchaUtils
import OlchaUI
extension SettingsViewController: TableDelegates {
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !isSeparator(indexPath) else {
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            cell.responder.height = 1
            cell.responder.withSeparator = true
            cell.responder.withEdge = true
            return cell
        }
        
        switch sections[indexPath.section] {
        case.language:
            let cell = tableView.dequeue(SettingsLanguageRoom.self, for: indexPath)
            cell.setup()
            return cell
        case .push:
            let cell = tableView.dequeue(SettingsPushRoom.self, for: indexPath)
            cell.setup()
            return cell
        case .offerta:
            let cell = tableView.dequeue(SafetyTitleRoom.self, for: indexPath)
            cell.setup(with: "offerta".localized(.olchaNasiyaModule))
            return cell
        case .about:
            let cell = tableView.dequeue(SafetyTitleRoom.self, for: indexPath)
            cell.setup(with: "about_app".localized(.olchaNasiyaModule))
            return cell
        case .clearTooltipCache:
            let cell = tableView.dequeue(HeaderRoom.self, for: indexPath)
            cell.responder.titleLabel.style(.medium, 14)
            cell.responder.titleLabel.textColor = .olchaLightTextColornnnnnn
            cell.responder.titleLabel.text = "settings_clear_tooptip_cache".localized(.olchaNasiyaModule)
            return cell
        }
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case.language:
            coordinator?.pushLanguage()
        case .offerta:
            openURL(Texts.socialUrl.publicOffer)
        case .about:
            coordinator?.pushAboutApp()
        case .clearTooltipCache:
            clearTooltipCache()
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        default:
            break
        }
    }
    
    private func isSeparator(_ indexPath: IndexPath) -> Bool {
        indexPath.row == 1
    }
    
}

extension SettingsViewController {
    public enum Section {
        case language
        case push
        case offerta
        case about
        case clearTooltipCache

    }
}
