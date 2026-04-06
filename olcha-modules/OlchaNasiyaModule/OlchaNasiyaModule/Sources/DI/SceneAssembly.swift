//
//  SceneAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import Foundation
import Swinject
final class SceneAssembly: Assembly {
    func assemble(container: Container) {
        let assemblies: [Assembly] = [
            OnboardingViewAssembly(),
            MenuViewAssembly(),
            
            InstallmentViewModelAssembly(),
            InstallmentViewAssembly(),
            
            HomeViewModelAssembly(),
            HomeViewAssembly(),
            
            PartnerViewModelAssembly(),
            PartnerViewAssembly(),
            
            ProfileViewModelAssembly(),
            ProfileViewAssembly()
        ]
        
        assemblies.forEach { $0.assemble(container: container) }
    }
}
