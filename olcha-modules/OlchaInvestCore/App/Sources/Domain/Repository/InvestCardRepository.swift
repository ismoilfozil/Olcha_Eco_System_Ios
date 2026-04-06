//
//  InvestCardRepository.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 22/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaCore
import Combine

public protocol InvestCardRepositoryProtocol {
    func loadCards() -> AnyPublisher<BaseResponse<CardData, EmptyData>, Never>
    func sendOtp(model: CardSendOtpRequest) -> AnyPublisher<BaseResponse<CardSendOtpResponse, EmptyData>, Never>
    func confirmOtp(model: CardConfirmOtpRequest) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public class InvestCardRepository: BaseRepository, InvestCardRepositoryProtocol {
    public func loadCards() -> AnyPublisher<BaseResponse<CardData, EmptyData>, Never> {
        let api: CardApi = .cards
        return manager.request(api: api)
    }
    
    public func sendOtp(model: CardSendOtpRequest) -> AnyPublisher<BaseResponse<CardSendOtpResponse, EmptyData>, Never> {
        let api: CardApi = .sendOtp(card: model)
        return manager.request(api: api)
    }
    
    public func confirmOtp(model: CardConfirmOtpRequest) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        let api: CardApi = .confirmOtp(card: model)
        return manager.request(api: api)
    }
}

//public class InvestCardMockRepository: InvestCardRepositoryProtocol {
//    
//    public func loadCards() -> AnyPublisher<BaseResponse<CardData, EmptyData>, Never> {
//        return Future { promise in
//            promise(.success(
//                BaseResponse(
//                    status: .success,
//                    error: nil,
//                    response: CardData.mock(),
//                    code: 200,
//                    errors: nil
//                )
//            ))
//        }.eraseToAnyPublisher()
//    }
//    
//    public func sendOtp(model: CardSendOtpRequest) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
//        return Future { promise in
//            promise(.success(
//                BaseResponse(
//                    status: .success,
//                    error: nil,
//                    response: CardData.mock(),
//                    code: 200,
//                    errors: nil
//                )
//            ))
//        }.eraseToAnyPublisher()
//    }
//    
//    public func confirmOtp(model: CardConfirmOtpRequest) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
//        
//    }
//    
//}
