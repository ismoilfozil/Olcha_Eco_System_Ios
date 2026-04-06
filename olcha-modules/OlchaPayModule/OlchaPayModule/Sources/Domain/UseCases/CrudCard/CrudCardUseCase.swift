//
//  AddCardUseCase.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 17/03/23.
//

import Foundation
import Combine
import OlchaCore
public protocol AddCardOTPProtocol {
    func execute(model: CardModel) -> AnyPublisher<BaseResponse<BalancesData, ValidationErrors>, Never>
}

public protocol VerifyOTPProtocol {
    func execute(model: CardModel) -> AnyPublisher<BaseResponse<BalancesData, ValidationErrors>, Never>
}

public protocol RemoveCardProtocol {
    func execute(id: Int) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public protocol UpdateCardProtocol {
    func execute(id: Int, model: UserBankCardModel) -> AnyPublisher<BaseResponse<UserBankCardModel, EmptyData>, Never>
}

public enum CrudCardUseCase {
    public class AddCardOTP: AddCardOTPProtocol {
        
        private var crudCardRepository: CrudCardRepositoryProtocol
        
        public init(crudCardRepository: CrudCardRepositoryProtocol) {
            self.crudCardRepository = crudCardRepository
        }
        
        public func execute(model: CardModel) -> AnyPublisher<BaseResponse<BalancesData, ValidationErrors>, Never> {
            return crudCardRepository.addCardOTP(model: model)
        }
    }
    
    public class VerifyOtp: VerifyOTPProtocol {
        private var crudCardRepository: CrudCardRepositoryProtocol
        
        public init(crudCardRepository: CrudCardRepositoryProtocol) {
            self.crudCardRepository = crudCardRepository
        }
        
        public func execute(model: CardModel) -> AnyPublisher<BaseResponse<BalancesData, ValidationErrors>, Never> {
            
            return crudCardRepository.verifyOTP(model: model)
        }
    }
    
    public class RemoveCard: RemoveCardProtocol {
        
        private var crudCardRepository: CrudCardRepositoryProtocol
        
        public init(crudCardRepository: CrudCardRepositoryProtocol) {
            self.crudCardRepository = crudCardRepository
        }
        
        public func execute(id: Int) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            return crudCardRepository.removeCard(id: id)
        }
        
    }
    
    public class UpdateCard: UpdateCardProtocol {
        
        private var crudCardRepository: CrudCardRepositoryProtocol
        
        public init(crudCardRepository: CrudCardRepositoryProtocol) {
            self.crudCardRepository = crudCardRepository
        }
        
        public func execute(id: Int, model: UserBankCardModel) -> AnyPublisher<BaseResponse<UserBankCardModel, EmptyData>, Never> {
            return crudCardRepository.updateCard(id: id, model: model)
        }
    }
}
