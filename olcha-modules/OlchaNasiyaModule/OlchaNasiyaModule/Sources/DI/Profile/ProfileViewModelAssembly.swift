//
//  ProfileViewAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 22/05/23.
//
import Foundation
import Swinject

final class ProfileViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NasiyaProfileViewModel.self) { r in
            let loadProfileUseCase = r.resolve(LoadProfileProtocol.self)!
            let editProfileUseCase = r.resolve(EditProfileProtocol.self)!
            
            return NasiyaProfileViewModel(
                loadProfileUseCase: loadProfileUseCase,
                editProfileUseCase: editProfileUseCase
            )
        }
        
    }
}
