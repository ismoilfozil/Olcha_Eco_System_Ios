//
//  ProfileDataPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 22/09/22.
//

import OlchaUI
import UIKit

extension ProfileDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .photo:
            return 1
        case .user:
            return userSectionRows.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .photo:
            
            let cell = tableView.dequeue(ProfilePhotoRoom.self, for: indexPath)
            cell.setup(name: (user?.name ?? "") + " " + (user?.lastname ?? ""),
                       title: "name_lastname".localized(),
                       isVerified: false)
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
            case .password:
                title = "password".localized()
                value = "*****"
                break
            }
            let cell = tableView.dequeue(ProfileDataRoom.self, for: indexPath)
            cell.setup(title: title, value: value, withRight: withIcon)
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let section = sections[indexPath.section]
        switch section {
        case .photo:
            coordinator?.presentEditName(user: user, observer: userUpdateObserver)
            break
            
        case .user:
            let row = userSectionRows[indexPath.row]
            
            switch row {
            case .id: break
            case .phone: break
            case .birthday:
                presentDatePicker()
                break
            case .mail:
                coordinator?.presentEditMail(user: user, observer: userUpdateObserver)
                break
            case .password:
                coordinator?.presentEditPassword()
                break
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
