//
//  SceneAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 26/01/23.
//

import Foundation
import Swinject
final class SceneAssembly: Assembly {
    func assemble(container: Container) {
        let assemblies: [Assembly] = [
            HomeViewAssembly(),
            HomeViewModelAssembly(),
            
            CardsAssembly(),
            CardsViewModelAssembly(),
            
            PaymentsViewAssembly(),
            PaymentsViewModelAssembly(),
            
            ProfileViewAssembly(),
            ProfileViewModelAssembly(),
            
            TransactionsViewAssembly(),
            TransactionsViewModelAssembly(),
            
            SavedTransactionsViewAssembly(),
            SavedTransactionsViewModelAssembly(),
            
            OnboardingAssembly()
        ]
        
        assemblies.forEach { $0.assemble(container: container) }
    }
}
