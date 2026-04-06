//
//  SavedTransactionsViewAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/04/23.
//

import Foundation
import Swinject
final class SavedTransactionsViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SavedTransactionsViewController.self) { r in
            let viewModel = r.resolve(SavedTransactionsViewModel.self, name: "shared")!
            return SavedTransactionsViewController(viewModel: viewModel)
        }
    }
}
