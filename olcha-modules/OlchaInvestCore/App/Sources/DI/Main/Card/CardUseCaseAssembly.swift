//
//  CardUseCaseAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 23/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject

final class CardUseCaseAssembly: Swinject.Assembly {
    
    func assemble(container: Swinject.Container) {
        container.register(LoadCardsProtocol.self) { resolver in
            let repository = resolver.resolve(InvestCardRepositoryProtocol.self)!
            return CardsUseCase.LoadCards(repository: repository)
        }
        
        container.register(CardSendOtpProtocol.self) { resolver in
            let repository = resolver.resolve(InvestCardRepositoryProtocol.self)!
            return CardsUseCase.CardSendOtp(repository: repository)
        }
        
        container.register(CardConfirmOtpProtocol.self) { resolver in
            let repository = resolver.resolve(InvestCardRepositoryProtocol.self)!
            return CardsUseCase.CardConfirmOtp(repository: repository)
        }
        
        container.register(StoreContractProtocol.self) { resolver in
            let repository = resolver.resolve(InvestHomeRepositoryProtocol.self)!
            return InvestorUseCase.StoreContract(repository: repository)
        }
    }
    
}
