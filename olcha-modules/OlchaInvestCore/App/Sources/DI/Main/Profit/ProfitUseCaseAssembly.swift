//
//  ProfitUseCaseAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 08/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject

public final class ProfitUseCaseAssembly: Assembly {
    
    public func assemble(container: Container) {
        container.register(WithdrawProfitProtocol.self) { resolver in
            let repository = resolver.resolve(InvestProfitRepositoryProtocol.self)!
            return ProfitUseCase.WithdrawProfit(repository: repository)
        }
        
        container.register(AutoWithdrawalProfitProtocol.self) { resolver in
            let repository = resolver.resolve(InvestProfitRepositoryProtocol.self)!
            return ProfitUseCase.AutoWithdrawalProfit(repository: repository)
        }
        
        container.register(ToggleAutoWithdrawalStatusProtocol.self) { resolver in
            let repository = resolver.resolve(InvestProfitRepositoryProtocol.self)!
            return ProfitUseCase.ToggleAutoWithdrawalStatus(repository: repository)
        }
        
        container.register(StoreAutoWithdrawProtocol.self) { resolver in
            let repository = resolver.resolve(InvestProfitRepositoryProtocol.self)!
            return ProfitUseCase.StoreAutoWithdraw(repository: repository)
        }
    }
    
}
