//
//  InstallmentViewModelAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import Foundation
import Swinject
final class InstallmentViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(InstallmentViewModel.self) { r in
            let loadInstallmentsUseCase = r.resolve(LoadInstallmentsProtocol.self)!
            let loadInstallmentUseCase = r.resolve(LoadInstallmentProtocol.self)!
            return InstallmentViewModel(
                loadInstallmentsUseCase: loadInstallmentsUseCase,
                loadInstallmentUseCase: loadInstallmentUseCase
            )
        }
    }
}
