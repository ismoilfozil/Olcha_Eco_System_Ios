//
//  CardAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 22/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject

final class CardAssembly: Swinject.Assembly {

    func assemble(container: Container) {
        container.register(InvestCardViewModel.self) { resolver in
            let loadCardsUseCase = resolver.resolve(LoadCardsProtocol.self)!
            let cardSendOtpUseCase = resolver.resolve(CardSendOtpProtocol.self)!
            let cardConfirmOtpUseCase = resolver.resolve(CardConfirmOtpProtocol.self)!
            let withdrawProfitUseCase = resolver.resolve(WithdrawProfitProtocol.self)!
            let autoWithdrawUseCase = resolver.resolve(AutoWithdrawalProfitProtocol.self)!
            let storeContractUseCase = resolver.resolve(StoreContractProtocol.self)!
            let storeAutoWithdrawUseCase = resolver.resolve(StoreAutoWithdrawProtocol.self)!
            return InvestCardViewModel(
                loadCardsUseCase: loadCardsUseCase,
                cardSendOtpUseCase: cardSendOtpUseCase,
                cardConfirmOtpUseCase: cardConfirmOtpUseCase,
                withdrawProfitUseCase: withdrawProfitUseCase,
                autoWithdrawUseCase: autoWithdrawUseCase,
                storeContractUseCase: storeContractUseCase,
                storeAutoWithdrawUseCase: storeAutoWithdrawUseCase
            )
        }
        
        container.register(InvestAddCardViewController.self) { resolver in
            let viewModel = resolver.resolve(InvestCardViewModel.self)!
            return InvestAddCardViewController(viewModel: viewModel)
        }
    }
    
}
