//
//  ScenePincodeAssembly.swift
//  OlchaPincode
//
//  Created by Elbek Khasanov on 19/05/23.
//

import Foundation
import Swinject

final class SceneAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ProfileViewController.self) { r in
            return ProfileViewController()
        }
    }
}
