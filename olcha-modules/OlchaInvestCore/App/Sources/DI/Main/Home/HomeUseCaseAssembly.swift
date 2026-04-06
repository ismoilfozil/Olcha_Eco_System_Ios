//
//  HomeUseCaseAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 17/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject

final class HomeUseCaseAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(LoadNotificationsProtocol.self) { resolver in
            let repository = resolver.resolve(InvestHomeRepositoryProtocol.self)!
            return NotificationsUseCase.LoadNotifications(repository: repository)
        }
        container.register(LoadInvestsProtocol.self) { resolver in
            let repository = resolver.resolve(InvestHomeRepositoryProtocol.self)!
            return InvestorUseCase.LoadInvests(repository: repository)
        }
        container.register(LoadAccountProtocol.self) { resolver in
            let repository = resolver.resolve(InvestHomeRepositoryProtocol.self)!
            return InvestorUseCase.LoadAccount(repository: repository)
        }
        container.register(LoadContractProtocol.self) { resolver in
            let repository = resolver.resolve(InvestHomeRepositoryProtocol.self)!
            return InvestorUseCase.LoadContract(repository: repository)
        }
        container.register(LoadContractHistoryProtocol.self) { resolver in
            let repository = resolver.resolve(InvestHomeRepositoryProtocol.self)!
            return InvestorUseCase.LoadContractHistory(repository: repository)
        }
        container.register(LoadContractChartProtocol.self) { resolver in
            let repository = resolver.resolve(InvestHomeRepositoryProtocol.self)!
            return InvestorUseCase.LoadContractChart(repository: repository)
        }
        container.register(LoadWithdrawHistoryProtocol.self) { resolver in
            let repository = resolver.resolve(InvestHomeRepositoryProtocol.self)!
            return InvestorUseCase.LoadWithdrawHistory(repository: repository)
        }
        container.register(ToggleContractStatusProtocol.self) { resolver in
            let repository = resolver.resolve(InvestHomeRepositoryProtocol.self)!
            return ContractUseCase.ToggleContractStatus(repository: repository)
        }
        container.register(DeleteContractUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(InvestHomeRepositoryProtocol.self)!
            return ContractUseCase.DeleteContract(repository: repository)
        }
    }
    
}
