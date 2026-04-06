//
//  ProfileDataViewController+Table.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 22/05/23.
//

import UIKit
import OlchaUI
extension PersonalDataViewController {
    
    public class FieldsFactory {
        public static let horizontal_tag = 101
        
        public let idField: InvestTField = {
            let field = InvestTField()
            field.topHint = "person_id".localized(.olchaInvestCore)
            field.canUseRules = false
            return field
        }()
        
        public let lastnameField: InvestTField = {
            let field = InvestTField()
            field.topHint = "lastname".localized()
            field.type = .required
            return field
        }()
        
        public let nameField: InvestTField = {
            let field = InvestTField()
            field.topHint = "name".localized()
            field.type = .required
            return field
        }()
        
        public let phoneField: InvestTField = {
            let field = InvestTField()
            field.type = .shortPhone
            field.topHint = "phone".localized()
            field.canUseRules = false
            return field
        }()
        
        public let extraPhoneField: InvestTField = {
            let field = InvestTField()
            field.type = .shortPhone
            field.topHint = "extra_phone".localized()
            return field
        }()
        
        public let passportField: InvestTField = {
            let field = InvestTField()
            field.tag = FieldsFactory.horizontal_tag
            field.topHint = "passport".localized()
            field.type = .required
            field.canUseRules = false
            return field
        }()
        
        public let birthdateField: InvestTField = {
            let field = InvestTField()
            field.topHint = "birthday".localized()
            field.enableButton = true
            field.type = .required
            return field
        }()
        
        public let mailField: InvestTField = {
            let field = InvestTField()
            field.topHint = "mail".localized()
            field.type = .required
            return field
        }()
        
        public let addressField: InvestTField = {
            let field = InvestTField()
            field.topHint = "address_doc".localized()
            field.type = .required
            return field
        }()
        
        public lazy var allFields: [InvestTField] = [
            idField,
            lastnameField,
            nameField,
            phoneField,
//            extraPhoneField,
//            passportField,
            birthdateField,
//            mailField,
//            addressField
        ]
        
        public lazy var allSubviews: [UIView] = {
            var subviews: [UIView] = []
            let totalCount = allFields.count
            
            guard totalCount > 0 else {
                return subviews
            }
            
            var index = 0
            
            while index < totalCount {
                let field = allFields[index]
                
                if field.tag == FieldsFactory.horizontal_tag && index + 1 < totalCount {
                    let stackView = UIStackView()
                    stackView.alignment = .top
                    stackView.axis = .horizontal
                    stackView.spacing = 16
                    stackView.distribution = .fillEqually
                    
                    stackView.addArrangedSubview(field)
                    
                    let nextField = allFields[index + 1]
                    stackView.addArrangedSubview(nextField)
                    
                    subviews.append(stackView)
                    index += 2
                } else {
                    subviews.append(field)
                    index += 1
                }
            }
            
            return subviews
        }()
        
        public lazy var stateFields: [FieldTypes: InvestTField] = [
            .id: idField,
            .name: nameField,
            .lastname: lastnameField,
            .phone: phoneField,
//            .extraPhone: extraPhoneField,
//            .passport: passportField,
            .birthdate: birthdateField,
//            .mail: mailField,
//            .address: addressField
        ]
       
    }
    
    public func fillEditingUser() {
        for (key, value) in output.factory.stateFields {
            switch key {
            case .name:
                output.editingUserModel?.name = value.getValue()
            case .lastname:
                output.editingUserModel?.lastname = value.getValue()
//            case .extraPhone:
//                output.editingUserModel?.extra_phone = value.getValue()
//            case .address:
//                output.editingUserModel?.address = value.getValue()
//            case .mail:
//                output.editingUserModel?.mail = value.getValue()
            case .birthdate:
                output.editingUserModel?.birthdate = value.getValue()
            default: break
            }
        }
    }
    
    public func fillFields() {
        for (key, value) in output.factory.stateFields {
            switch key {
            case .id:
                value.setValue(string: output.userModel?.id?.string)
            case .name:
                value.setValue(string: output.userModel?.name)
            case .lastname:
                value.setValue(string: output.userModel?.lastname)
            case .phone:
                value.setValue(string: output.userModel?.phone)
//            case .extraPhone:
//                value.setValue(string: output.userModel?.extra_phone)
//            case .address:
//                value.setValue(string: output.userModel?.address)
//            case .mail:
//                value.setValue(string: output.userModel?.mail)
            case .birthdate:
                value.setValue(string: output.userModel?.birthdate)
//            case .passport:
//                value.setValue(string: output.userModel?.passport)
            }
        }
    }
}

extension PersonalDataViewController {
    public enum FieldTypes {
        case id
        case name
        case lastname
        case phone
//        case extraPhone
//        case passport
        case birthdate
//        case mail
//        case address
    }
}
