//
//  ProfileDataPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 22/09/22.
//


import UIKit
import OlchaUtils
import OlchaUI
extension ProfileDataPage: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .photo:
            return 1
        case .user:
            return userSectionRows.count
        case .cards:
            return cards.isEmpty ? 0 : cards.count + 1
        case .password:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .photo:
            
            let cell = tableView.dequeue(ProfilePhotoRoom.self, for: indexPath)
            cell.setup(name: (user?.name ?? "") + " " + (user?.lastname ?? ""),
                       isVerified: step?.is_verified ?? false)
            return cell
        case .user:
            let row = userSectionRows[indexPath.row]
            var title = " "
            var value = " "
            var withIcon = true
            switch row {
            case .id:
                title = "id".localized()
                if let id = user?.id {
                    value = id.string
                }
                withIcon = false
                break
            case .phone:
                title = "phone_number".localized()
                value = user?.phone?.formatFullPhoneNumber ?? ""
                withIcon = false
                break
            case .birthday:
                title = "birthday".localized()
                value = user?.birthdate ?? ""
                break
            case .mail:
                title = "mail".localized()
                value = user?.email ?? ""
                break
            case .address:
                title = "address_doc".localized()
                withIcon = false
                break
            case .extraPhone:
                title = "extra_phone".localized()
                break
            case .passport:
                title = "passport".localized()
                withIcon = false
                break
            }
            let cell = tableView.dequeue(ProfileDataRoom.self, for: indexPath)
            cell.setup(title: title, value: value, withRight: withIcon)
            return cell
        case .cards:
            if indexPath.row == 0 {
                let cell = tableView.dequeue(ProfileDataHeaderRoom.self, for: indexPath)
                cell.setup(with: "attached_cards".localized())
                return cell
            } else {
                let cell = tableView.dequeue(ProfileDataRoom.self, for: indexPath)
                cell.setup(title: "card".localized() + " " + indexPath.row.string,
                           value: cards[indexPath.row - 1].card_number?.hideCardNumber,
                           withRight: true)
                return cell
            }
        case .password:
            if indexPath.row == 0 {
                let cell = tableView.dequeue(ProfileDataHeaderRoom.self, for: indexPath)
                cell.setup(with: "password".localized())
                return cell
            } else {
                let cell = tableView.dequeue(ProfileDataRoom.self, for: indexPath)
                cell.setup(title: "current_password".localized(), value: "*******", withRight: true)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let section = sections[indexPath.section]
        switch section {
        case .photo:
            coordinator?.presentEditName(user: user, userUpdateObserver: userUpdateObserver)
            break
            
        case .user:
            let row = userSectionRows[indexPath.row]
            
            switch row {
            case .id:
                
                break
            case .phone:
                
                break
            case .birthday:
                presentDatePicker()
                break
            case .mail:
                coordinator?.presentEditMail(user: user, userUpdateObserver: userUpdateObserver)
                break
            case .address:
                
                break
            case .extraPhone:
                
                break
            case .passport:
                
                break
            }
            
        case .cards:
            if indexPath.row != 0 {
                coordinator?.pushBankCardsPage()
            }
        case .password:
            if indexPath.row != 0 {
                coordinator?.presentPassword()
            }
        }
    }
    
    func presentDatePicker() {
        if datePicker == nil {
            datePicker = UDatePicker(frame: view.frame, willDisappear: { [weak self] date in
                guard let self = self else { return }
                if let date = date {
                    
                    self.user?.birthdate = date.string
                    
                    self.userUpdateObserver.send(true)
                }
            })
            
        }
        datePicker?.configure(dateString: user?.birthdate)
        datePicker?.picker.datePicker.maximumDate = Date()
        datePicker?.present(self)
    }
}
