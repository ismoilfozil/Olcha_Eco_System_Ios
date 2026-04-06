//
//  MainUseCaseAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import Foundation
import Swinject
final class HomeUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(LoadLimitProtocol.self) { r in
            let repository = r.resolve(NasiyaHomeRepositoryProtocol.self)!
            return HomeUseCase.LoadLimit(repository: repository)
        }
        
        container.register(RequestLimitProtocol.self) { r in
            let repository = r.resolve(NasiyaHomeRepositoryProtocol.self)!
            return HomeUseCase.RequestLimit(repository: repository)
        }
        
    }
}
