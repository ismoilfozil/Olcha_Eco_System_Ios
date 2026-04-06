//
//  HomeAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 17/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject

final class HomeAssembly: Swinject.Assembly {
    
    func assemble(container: Swinject.Container) {
        container.register(InvestHomeViewModel.self) { r in
            let loadNotificationsUseCase = r.resolve(LoadNotificationsProtocol.self)!
            let loadInvestsUseCase = r.resolve(LoadInvestsProtocol.self)!
            let loadAccountUseCase = r.resolve(LoadAccountProtocol.self)!
            return InvestHomeViewModel(loadNotificationsUseCase: loadNotificationsUseCase, loadInvestsUseCase: loadInvestsUseCase, loadAccountUseCase: loadAccountUseCase)
        }
        
        container.register(InvestHomeViewController.self) { resolver in
            let viewModel = resolver.resolve(InvestHomeViewModel.self)!
            return InvestHomeViewController(viewModel: viewModel)
        }
        
        container.register(InvestHomeModalViewController.self) { resolver in
            return InvestHomeModalViewController()
        }
        
        container.register(ReinvestViewController.self) { resolver in
            return ReinvestViewController()
        }
        
        container.register(ContractViewModel.self) { resolver in
            let loadContractUseCase = resolver.resolve(LoadContractProtocol.self)!
            let loadContractHistoryUseCase = resolver.resolve(LoadContractHistoryProtocol.self)!
            let loadContractChartUseCase = resolver.resolve(LoadContractChartProtocol.self)!
            let toggleContractStatusUseCase = resolver.resolve(ToggleContractStatusProtocol.self)!
            let toggleAutoWithdrawalStatusUseCase = resolver.resolve(ToggleAutoWithdrawalStatusProtocol.self)!
            let deleteContractUseCase = resolver.resolve(DeleteContractUseCaseProtocol.self)!
            let loadWithdrawHistoryUseCase = resolver.resolve(LoadWithdrawHistoryProtocol.self)!
            return ContractViewModel(
                loadContractUseCase: loadContractUseCase,
                loadContractHistoryUseCase: loadContractHistoryUseCase,
                loadContractChartUseCase: loadContractChartUseCase,
                toggleContractStatusUseCase: toggleContractStatusUseCase,
                toggleAutoWithdrawalStatusUseCase: toggleAutoWithdrawalStatusUseCase,
                deleteContractUseCase: deleteContractUseCase,
                loadWithdrawHistory: loadWithdrawHistoryUseCase
            )
        }
        
        container.register(ContractViewController.self) { resolver in
            let viewModel = resolver.resolve(ContractViewModel.self)!
            return ContractViewController(viewModel: viewModel)
        }
        
        container.register(ContractPauseReasonModalViewController.self) { resolver in
            
            return ContractPauseReasonModalViewController()
        }
    }
    
}
