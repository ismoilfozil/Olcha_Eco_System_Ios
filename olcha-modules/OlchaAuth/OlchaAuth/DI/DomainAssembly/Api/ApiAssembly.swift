//
//  ApiAssembly.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 09/08/23.
//
import Foundation
import Swinject
final class ApiAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ProfileAPIProtocol.self) { r in
            return ProfileAPI()
        }
        
        container.register(LoginAPIProtocol.self) { (r) in
            switch AuthTexts.type {
                case .mobile:
                    return OldOlchaAuthAPI()
                case .auth:
                    return LoginAPI()
            }
        }
        
        container.register(AuthAPIProtocol.self) { (r) in
            switch AuthTexts.type {
                case .mobile:
                    return OldOlchaAuthAPI()
                case .auth:
                    return AuthAPI()
            }
        }
    }
}
