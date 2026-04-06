//
//  AddCardRepository.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 17/03/23.
//

import Foundation
import Combine
import OlchaCore
public protocol CrudCardRepositoryProtocol {
    
    func updateCard(id: Int, model: UserBankCardModel) -> AnyPublisher<(BaseResponse<UserBankCardModel, EmptyData>), Never>
    
    func removeCard(id: Int) -> AnyPublisher<(BaseResponse<EmptyData, EmptyData>), Never>
    
    func verifyOTP(model: CardModel) -> AnyPublisher<(BaseResponse<BalancesData, ValidationErrors>), Never>
    
    func addCardOTP(model: CardModel) -> AnyPublisher<(BaseResponse<BalancesData, ValidationErrors>), Never>
    
}

public class CrudCardRepository: BaseRepository, CrudCardRepositoryProtocol {
    public func updateCard(id: Int, model: UserBankCardModel) -> AnyPublisher<(BaseResponse<UserBankCardModel, EmptyData>), Never> {
        let api: CrudCardAPI = .update(id: id,
                                       model: .init(
                                        color: model.color,
                                        status: model.status,
                                        cardName: model.cardName))
        return manager.request(api: api)
    }
    
    public func removeCard(id: Int) -> AnyPublisher<(BaseResponse<EmptyData, EmptyData>), Never> {
        let api: CrudCardAPI = .remove(id: id)
        return manager.request(api: api)
    }
    
    public func verifyOTP(model: CardModel) -> AnyPublisher<(BaseResponse<BalancesData, ValidationErrors>), Never> {
        let api: CrudCardAPI = .verifyOTP(
            model: .init(pan: model.getPan(),
                         expiry: model.getExpiry(),
                         code: model.code,
                         isTrusted: true,
                         cardName: model.name)
        )
        return manager.request(api: api)
    }
    
    public func addCardOTP(model: CardModel) -> AnyPublisher<(BaseResponse<BalancesData, ValidationErrors>), Never> {
        let api: CrudCardAPI = .addCardOTP(
            model: .init(pan: model.getPan(),
                         expiry: model.getExpiry(),
                         cardName: model.name)
        )
        return manager.request(api: api)
    }
    
    
}
