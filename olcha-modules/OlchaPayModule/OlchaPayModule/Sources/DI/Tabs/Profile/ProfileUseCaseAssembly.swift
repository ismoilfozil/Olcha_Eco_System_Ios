//
//  ProfileUseCaseAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 24/03/23.
//

import Foundation
import Foundation
import Swinject
final class ProfileUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoadNewsProtocol.self) { r in
            let repository = r.resolve(NewsRepositoryProtocol
                                        .self)!
            return NewsUseCase.LoadNews(repository: repository)
        }
        
    }
}

