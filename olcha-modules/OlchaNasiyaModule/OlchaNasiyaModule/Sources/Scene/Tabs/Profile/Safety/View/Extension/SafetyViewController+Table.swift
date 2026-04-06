//
//  SafetyViewController+Table.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 23/05/23.
//

import UIKit
import OlchaUI
extension SafetyViewController: TableDelegates {
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard !isSeparator(indexPath) else {
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            cell.responder.withSeparator = true
            cell.responder.height = 1
            return cell
        }
        
        switch section {
        case .biometric:
            let cell = tableView.dequeue(SafetyPincodeRoom.self, for: indexPath)
            cell.permissionClickedObserver = { [weak self] in
                guard let self = self else { return }
                showBiometricPermissionAlert()
            }
            return cell
        default:
            let cell = tableView.dequeue(SafetyTitleRoom.self, for: indexPath)
            cell.setup(with: section.title)
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch sections[indexPath.section] {
        case .biometric:
            break
        case .pincode:
            coordinator?.pushEditPincode()
        case .password:
            coordinator?.presentEditPassword()
        }
    }
    
    private func isSeparator(_ indexPath: IndexPath) -> Bool {
        switch sections[indexPath.section] {
        case .biometric:
            return indexPath.row == 1
        case .password:
            return indexPath.row == 1
        case .pincode:
            return indexPath.row == 1
        }
    }
}

extension SafetyViewController {
    public enum Section {
        case biometric
        case pincode
        case password
        
        public var title: String {
            switch self {
            case .pincode:
                return "edit_pincode".localized(.pincode)
            case .password:
                return "password".localized()
            default:
                return ""
            }
        }
    }
}
