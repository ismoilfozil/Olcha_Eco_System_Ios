//
//  SettingsViewController+Table.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 28/02/23.
//

import UIKit
import OlchaUI
import OlchaAuth
import OlchaUtils
extension ProfileViewController: TableDelegates {
    
    public enum Section {
        case user
        case olcha
        case ecoSystem
        case notifications
        case settings
        case support
        case logout
        
        var image: UIImage? {
            switch self {
            case .notifications:
                return .notifications
            case .olcha:
                return .olcha_market
            case .ecoSystem:
                return .olchaIcon
            case .settings:
                return .settings
            case .support:
                return .support
            case .logout:
                return .logout
            default:
                return nil
            }
        }
        
        var title: String {
            switch self {
            case .user:
                return ""
            case .olcha:
                return "Olcha"
            case .ecoSystem:
                return "Olcha EcoSystem"
            case .notifications:
                return "notifications".localized()
            case .settings:
                return "settings".localized()
            case .support:
                return "support".localized()
            case .logout:
                return "logout".localized()
            }
        }
        
        var accentColor: UIColor? {
            switch self {
            case .logout:
                return .olchaAccentColor
            default:
                return nil
            }
        }
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard !isSeparator(at: indexPath) else {
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            cell.responder.withEdge = true
            cell.responder.height = (section != .user) ? 1 : 16
            cell.responder.withSeparator = (section != .user)
            return cell
        }
        switch section {
        case .user:
            let cell = tableView.dequeue(UserRoom.self, for: indexPath)
            let userName = "\(user?.name ?? "") \(user?.lastname ?? "")"
            cell.setup(with: userName, status: .none)
            return cell
        default:
            let cell = tableView.dequeue(ProfileMenuRoom.self, for: indexPath)
            cell.setup(image: section.image,
                       title: section.title,
                       accentColor: section.accentColor)
            return cell
        }
        
    }
    
    private func isSeparator(at indexPath: IndexPath) -> Bool {
        (indexPath.item == 1)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let section = sections[indexPath.section]
        if !isSeparator(at: indexPath) {
            switch section {
            case .user:
                coordinator?.pushProfileData()
            case .olcha:
                ModuleGeneratorHelper.shared.generateParent()
            case .ecoSystem:
                ModuleGeneratorHelper.shared.generateParent()
            case .support:
                coordinator?.pushSupport()
            case .notifications:
                coordinator?.pushNotifications()
            case .settings:
                coordinator?.pushSettings()
            case .logout:
                showLogout {
                    PayAppConfigurator.shared.appCoordinator?.logout()
                }
            }
        }
    }
}
