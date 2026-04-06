//
//  UseCaseAssembly.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 09/08/23.
//

import Foundation
import Swinject
final class UseCaseAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        let assemblies: [Assembly] = [
            LoginUseCaseAssembly(),
            AuthUseCaseAssembly(),
            ProfileUseCaseAssembly()
        ]
        
        assemblies.forEach { $0.assemble(container: container) }
    }
}
