//
//  ViewModelAssembly.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 26/05/23.
//
import Foundation
import Swinject
import OlchaUtils
final class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AuthViewModel.self) { r in
            
            let checkPhoneUseCase = r.resolve(CheckPhoneProtocol.self)!
            let loginUseCase = r.resolve(LoginProtocol.self)!
            let confirmCodeUseCase = r.resolve(ConfirmCodeProtocol.self)!
            let registerPhoneCodeUseCase = r.resolve(RegisterPhoneCodeProtocol.self)!
            let getGuestTokenUseCase = r.resolve(GetGuestTokenProtocol.self)!
            let getUserTokenUseCase = r.resolve(GetUserTokenProtocol.self)!
            let getRefreshTokenUseCase = r.resolve(GetRefreshTokenProtocol.self)!
            let resetPhoneCodeUseCase = r.resolve(ResetPhoneCodeProtocol.self)!
            let renewPasswordUseCase = r.resolve(RenewPasswordProtocol.self)!
            let editPasswordUseCase = r.resolve(EditPasswordProtocol.self)!
            let storeUserDeviceUseCase = r.resolve(StoreUserDeviceProtocol.self)!
            let deleteUserDeviceUseCase = r.resolve(DeleteUserDeviceProtocol.self)!
            
            return AuthViewModel(checkPhoneUseCase: checkPhoneUseCase,
                                 loginUseCase: loginUseCase,
                                 confirmCodeUseCase: confirmCodeUseCase,
                                 registerPhoneCodeUseCase: registerPhoneCodeUseCase,
                                 getGuestTokenUseCase: getGuestTokenUseCase,
                                 getUserTokenUseCase: getUserTokenUseCase,
                                 getRefreshTokenUseCase: getRefreshTokenUseCase,
                                 resetPhoneCodeUseCase: resetPhoneCodeUseCase,
                                 renewPasswordUseCase: renewPasswordUseCase,
                                 editPasswordUseCase: editPasswordUseCase,
                                 storeUserDeviceUseCase: storeUserDeviceUseCase,
                                 deleteUserDeviceUseCase: deleteUserDeviceUseCase)
        }
        
        container.register(AuthViewModel.self, name: .shared) { r in
            return r.resolve(AuthViewModel.self)!
        }.inObjectScope(.container)
        
        container.register(ProfileViewModel.self) { r in
            let loadUserDataUseCase = r.resolve(LoadUserDataProtocol.self)!
            let editUserDataUseCase = r.resolve(EditUserDataProtocol.self)!
            let deleteUserUseCase = r.resolve(DeleteUserProtocol.self)!
            return ProfileViewModel(
                loadUserDataUseCase: loadUserDataUseCase,
                editUserDataUseCase: editUserDataUseCase,
                deleteUserUseCase: deleteUserUseCase
            )
        }
        
        container.register(ProfileViewModel.self, name: .shared) { r in
            let loadUserDataUseCase = r.resolve(LoadUserDataProtocol.self)!
            let editUserDataUseCase = r.resolve(EditUserDataProtocol.self)!
            let deleteUserUseCase = r.resolve(DeleteUserProtocol.self)!
            return ProfileViewModel(
                loadUserDataUseCase: loadUserDataUseCase,
                editUserDataUseCase: editUserDataUseCase,
                deleteUserUseCase: deleteUserUseCase
            )
        }.inObjectScope(.container)
    }
}
