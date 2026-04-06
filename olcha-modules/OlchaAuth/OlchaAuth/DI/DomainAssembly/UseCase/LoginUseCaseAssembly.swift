//
//  UseCaseAssembly.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 26/05/23.
//

import Foundation
import Swinject
final class LoginUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CheckPhoneProtocol.self) { r in
            let repository = r.resolve(LoginRepositoryProtocol.self)!
            return LoginUseCase.CheckPhone(repository: repository)
        }
        
        container.register(LoginProtocol.self) { r in
            let repository = r.resolve(LoginRepositoryProtocol.self)!
            return LoginUseCase.Login(repository: repository)
        }
        
        
        container.register(ConfirmCodeProtocol.self) { r in
            let repository = r.resolve(LoginRepositoryProtocol.self)!
            return LoginUseCase.ConfirmCode(repository: repository)
        }
        
        container.register(RegisterPhoneCodeProtocol.self) { r in
            let repository = r.resolve(LoginRepositoryProtocol.self)!
            return LoginUseCase.RegisterPhoneCode(repository: repository)
        }
        
        container.register(RenewPasswordProtocol.self) { r in
            let repository = r.resolve(LoginRepositoryProtocol.self)!
            return LoginUseCase.RenewPassword(repository: repository)
        }
        
        container.register(EditPasswordProtocol.self) { r in
            let repository = r.resolve(LoginRepositoryProtocol.self)!
            return LoginUseCase.EditPassword(repository: repository)
        }
        
        container.register(ResetPhoneCodeProtocol.self) { r in
            let repository = r.resolve(LoginRepositoryProtocol.self)!
            return LoginUseCase.ResetPhoneCode(repository: repository)
        }
        
        container.register(StoreUserDeviceProtocol.self) { r in
            let repository = r.resolve(AuthRepositoryProtocol.self)!
            return AuthUseCase.StoreUserDevice(repository: repository)
        }
        
        container.register(DeleteUserDeviceProtocol.self) { r in
            let repository = r.resolve(AuthRepositoryProtocol.self)!
            return AuthUseCase.DeleteUserDevice(repository: repository)
        }
    }
}
