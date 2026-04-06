//
//  ProfileDataViewController+IO.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 06/06/23.
//

import Foundation
import OlchaAuth
extension PersonalDataViewController {
    public struct Input {
        public init() {}
    }
    
    public struct Output {
        
        let factory = FieldsFactory()
        
        var userModel: User? = .init(name: nil, lastname: nil)
        
        var editingUserModel: User? =  .init(name: nil, lastname: nil)
        
        public init() {}
        
        public mutating func copyUser() {
            editingUserModel = userModel
        }
        
        public mutating func removeEditingUser() {
            editingUserModel = nil
        }
        
        public mutating func saveUser() {
            userModel = editingUserModel
        }
    }
}
