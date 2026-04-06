//
//  UseCaseAssembly.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 26/05/23.
//

import Foundation
import Swinject
final class ProfileUseCaseAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(LoadUserDataProtocol.self) { r in
            let repository = r.resolve(ProfileRepositoryProtocol.self)!
            return ProfileUseCase.LoadProfileData(repository: repository)
        }
        
        container.register(EditUserDataProtocol.self) { r in
            let repository = r.resolve(ProfileRepositoryProtocol.self)!
            return ProfileUseCase.EditUserData(repository: repository)
        }
        
        container.register(DeleteUserProtocol.self) { r in
            let repository = r.resolve(ProfileRepositoryProtocol.self)!
            return ProfileUseCase.DeleteUser(repository: repository)
        }
    }
}
