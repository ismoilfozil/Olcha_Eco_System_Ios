//
//  ProfileDataViewController+IO.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 06/06/23.
//
import OlchaAuth
import Foundation
extension ProfileDataViewController {
    public struct Input {
        public init() {}
    }
    
    public struct Output {
        
        let factory = FieldsFactory()
        
        var userModel: User? = User()
        
        var editingUserModel: User? =  User()
        
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
