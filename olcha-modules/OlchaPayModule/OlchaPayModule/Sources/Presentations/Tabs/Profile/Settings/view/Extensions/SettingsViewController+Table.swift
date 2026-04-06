//
//  SettingsViewController+Table.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 06/03/23.
//

import UIKit
import OlchaUI
extension SettingsViewController: TableDelegates {

    enum Section {
        case language
        case pincode
        case push
        case editPincode
    }
    
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
            cell.responder.withEdge = true
            cell.responder.withSeparator = true
            return cell
        }
        
        switch sections[indexPath.section] {
        case .language:
            let cell = tableView.dequeue(SettingsLanguageRoom.self, for: indexPath)
            cell.setup()
            return cell
        case .pincode:
            let cell = tableView.dequeue(SettingsPincodeRoom.self, for: indexPath)
            cell.setup()
            cell.permissionClickedObserver = { [weak self] in
                guard let self = self else { return }
                self.showBiometricPermissionAlert()
            }
            return cell
        case .push:
            let cell = tableView.dequeue(SettingsPushRoom.self, for: indexPath)
            cell.setup()
            return cell
        case .editPincode:
            let cell = tableView.dequeue(ProfileMenuRoom.self, for: indexPath)
            cell.setup(image: .locked, title: "edit_pincode".localized())
            return cell
        }
    }
    
    private func isSeparator( _ indexPath: IndexPath) -> Bool {
        indexPath.row == 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch sections[indexPath.section] {
        case .language:
            coordinator?.pushLanguage()
            break
        case .editPincode:
            coordinator?.pushEditPincode()
            break
        default:
            break
        }
    }
}
