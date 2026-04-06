//
//  InstallmentUseCaseAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import Foundation
import Swinject
final class InstallmentUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoadInstallmentsProtocol.self) { r in
            let repository = r.resolve(InstallmentRepositoryProtocol.self)!
            return InstallmentUseCase.LoadInstallments(repository: repository)
        }
        
        container.register(LoadInstallmentProtocol.self) { r in
            let repository = r.resolve(InstallmentRepositoryProtocol.self)!
            return InstallmentUseCase.LoadInstallment(repository: repository)
        }
    }
}
