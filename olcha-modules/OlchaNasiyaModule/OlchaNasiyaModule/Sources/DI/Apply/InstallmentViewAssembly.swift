//
//  InstallmentViewAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 15/05/23.
//

import Foundation
import Swinject
final class InstallmentViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MyInstallmentsViewController.self) { r in
            let viewModel = r.resolve(InstallmentViewModel.self)!
            return MyInstallmentsViewController(viewModel: viewModel)
        }
        
        container.register(MyInstallmentViewController.self) { r in
            let viewModel = r.resolve(InstallmentViewModel.self)!
            return MyInstallmentViewController(viewModel: viewModel)
        }
        
        container.register(InstallmentSortModal.self) { r in
            return InstallmentSortModal()
        }
        
        
    }
}
