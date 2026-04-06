//
//  ViewAssembly.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 26/05/23.
//

import Foundation
import Swinject

final class ViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SayohatWebViewController.self) { r in
            return SayohatWebViewController()
        }
    }
}
