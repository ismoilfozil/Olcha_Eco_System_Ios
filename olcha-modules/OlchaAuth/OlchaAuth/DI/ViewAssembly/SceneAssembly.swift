//
//  SceneAssembly.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 24/05/23.
//

import Foundation
import Swinject
final class SceneAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        let assemblies: [Assembly] = [
            ViewModelAssembly(),
            ViewAssembly()
        ]
        
        assemblies.forEach { $0.assemble(container: container) }
    }
}
