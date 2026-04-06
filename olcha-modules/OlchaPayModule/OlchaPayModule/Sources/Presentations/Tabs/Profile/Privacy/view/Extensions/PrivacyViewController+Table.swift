//
//  PrivacyViewController+Table.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/03/23.
//

import UIKit
import OlchaUI
import OlchaUtils
extension PrivacyViewController: TableDelegates {
    
    public enum Section {
        case offerta
        case privacy_policy
        case call
        case message
        
        var image: UIImage? {
            switch self {
            case .offerta:
                return .offerta
            case .privacy_policy:
                return .privacy_policy
            case .call:
                return .call_operator
            case .message:
                return .message_operator
            }
        }
        
        var title: String {
            switch self {
            case .offerta:
                return "public_offerta".localized()
            case .privacy_policy:
                return "privacy_policy".localized()
            case .call:
                return "call_center".localized()
            case .message:
                return "message_operator".localized()
            }
        }
        
        var url: String {
            switch self {
            case .offerta:
                return Texts.urls.offerta
            case .privacy_policy:
                return Texts.urls.privacy
            case .call:
                return Texts.urls.call
            case .message:
                return Texts.urls.message
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
        guard !isSeparator(indexPath) else {
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            cell.responder.withEdge = true
            cell.responder.withSeparator = true
            return cell
        }
        
        let cell = tableView.dequeue(ProfileMenuRoom.self, for: indexPath)
        cell.setup(image: sections[indexPath.section].image,
                   title: sections[indexPath.section].title)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isSeparator(indexPath) ? 1 : UITableView.automaticDimension
    }
    
    private func isSeparator(_ indexPath: IndexPath) -> Bool {
        indexPath.row == 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard !isSeparator(indexPath) else { return }
        switch sections[indexPath.section] {
        case .call:
            openPhone()
            break
        case .offerta:
            openSafari(urlString: Texts.urls.offerta)
            break
        case .privacy_policy:
            openSafari(urlString: Texts.urls.privacy)
            break
        case .message:
            openTelegram()
            break
        }
    }
}
