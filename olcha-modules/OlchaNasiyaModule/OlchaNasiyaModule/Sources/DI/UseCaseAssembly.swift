//
//  UseCaseAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import Foundation
import Swinject
final class UseCaseAssembly: Assembly {
    func assemble(container: Container) {
        let assemblies: [Assembly] = [
            InstallmentUseCaseAssembly(),
            HomeUseCaseAssembly(),
            
            PartnerUseCaseAssembly(),
            ProfileUseCaseAssembly()
        ]
        
        assemblies.forEach { $0.assemble(container: container) }
    }
}
