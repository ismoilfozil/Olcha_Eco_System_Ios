//
//  ProfileViewAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 22/05/23.
//
import Foundation
import Swinject

final class ProfileUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoadProfileProtocol.self) { r in
            let repository = r.resolve(ProfileRepositoryProtocol.self)!
            return ProfileUseCase.LoadProfile(repository: repository)
        }
        
        container.register(EditProfileProtocol.self) { r in
            let repository = r.resolve(ProfileRepositoryProtocol.self)!
            return ProfileUseCase.EditProfile(repository: repository)
        }
        
    }
}
