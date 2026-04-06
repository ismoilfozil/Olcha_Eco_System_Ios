//
//  CardsUseCase.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 22/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Combine
import OlchaCore

public protocol LoadCardsProtocol {
    func execute() -> AnyPublisher<BaseResponse<CardData, EmptyData>, Never>
}

public protocol CardSendOtpProtocol {
    func execute(model: CardSendOtpRequest) -> AnyPublisher<BaseResponse<CardSendOtpResponse, EmptyData>, Never>
}

public protocol CardConfirmOtpProtocol {
    func execute(model: CardConfirmOtpRequest) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public enum CardsUseCase {
    
    public class LoadCards: LoadCardsProtocol {
        private let repository: InvestCardRepositoryProtocol
        
        public init(repository: InvestCardRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<CardData, EmptyData>, Never> {
            repository.loadCards()
        }
    }
    
    public class CardSendOtp: CardSendOtpProtocol {
        
        private let repository: InvestCardRepositoryProtocol
        
        public init(repository: InvestCardRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(model: CardSendOtpRequest) -> AnyPublisher<BaseResponse<CardSendOtpResponse, EmptyData>, Never> {
            repository.sendOtp(model: model)
        }
        
    }
    
    public class CardConfirmOtp: CardConfirmOtpProtocol {
        
        private let repository: InvestCardRepositoryProtocol
        
        public init(repository: InvestCardRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(model: CardConfirmOtpRequest) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            repository.confirmOtp(model: model)
        }
        
    }
    
}
