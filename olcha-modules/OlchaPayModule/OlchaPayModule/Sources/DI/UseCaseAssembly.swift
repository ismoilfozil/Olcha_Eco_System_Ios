//
//  UseCaseAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 26/01/23.
//

import Foundation
import Swinject
final class UseCaseAssembly: Assembly {
    
    func assemble(container: Container) {
        let assemblies: [Assembly] = [
            CardsUseCaseAssembly(),
            ProfileUseCaseAssembly(),
            HomeUseCaseAssembly(),
            PaymentsUseCaseAssembly(),
            TransactionsUseCaseAssembly(),
            SavedTransactionsUseCaseAssembly()
        ]
        assemblies.forEach { $0.assemble(container: container) }
    }
    
}
