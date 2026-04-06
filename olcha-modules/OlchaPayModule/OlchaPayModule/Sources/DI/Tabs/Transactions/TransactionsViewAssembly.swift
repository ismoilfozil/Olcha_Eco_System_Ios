//
//  TransactionsViewAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 28/03/23.
//

import Foundation
import Swinject
final class TransactionsViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MonitoringViewController.self) { r in
            let viewModel = r.resolve(TransactionViewModel.self, name: .shared)!
            let crudCardViewModel = r.resolve(CrudCardViewModel.self, name: .shared)!
            return MonitoringViewController(viewModel: viewModel,
                                            crudCardViewModel: crudCardViewModel)
        }
        
        container.register(MonitoringFilterViewController.self) { r in
            let viewModel = r.resolve(TransactionViewModel.self, name: "shared")!
            return MonitoringFilterViewController(viewModel: viewModel)
        }
    }
}
