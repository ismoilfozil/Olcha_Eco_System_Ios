//
//  ProfileDataViewController+States.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 23/05/23.
//

import UIKit
extension PersonalDataViewController {
    public func stateChanged() {
        output.factory.stateFields.forEach { key, value in
            switch key {
//                case .passport
//                value.disableEditing(withBackground: editingMode)
            case .id, .phone:
                value.disableEditing(withBackground: editingMode)
            default:
                editingMode ? value.enableEditing() : value.disableEditing()
            }
            value.resignFirstResponder()
        }
        
        editButton.isHidden = editingMode
        cancelButton.isHidden = !editingMode
        saveButton.isHidden = !editingMode
    }
}
