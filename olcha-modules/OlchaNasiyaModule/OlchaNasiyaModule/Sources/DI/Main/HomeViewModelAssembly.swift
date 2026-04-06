//
//  MainViewModelAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import Foundation
import Swinject
final class HomeViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NasiyaHomeViewModel.self) { r in
            let loadLimitUseCase = r.resolve(LoadLimitProtocol.self)!
            let requestLimitUseCase = r.resolve(RequestLimitProtocol.self)!
            return NasiyaHomeViewModel(
                loadLimitUseCase: loadLimitUseCase,
                requestLimitUseCase: requestLimitUseCase
            )
        }
    }
}
