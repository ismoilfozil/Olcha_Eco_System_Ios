//
//  SceneAssembly.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 20/06/23.
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
