//
//  ProfileViewModelAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 24/03/23.
//
import Swinject
import Foundation
import OlchaAuth
final class ProfileViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NewsViewModel.self) { r in
            let loadNewsUseCase = r.resolve(LoadNewsProtocol.self)!
            return NewsViewModel(loadNewsUseCase: loadNewsUseCase)
        }
    }
}
