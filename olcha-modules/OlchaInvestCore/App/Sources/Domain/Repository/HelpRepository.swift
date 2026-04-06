//
//  HelpRepository.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaCore
import Combine

public protocol HelpRepositoryProtocol {
    func storeFeedback(investorId: Int, message: String) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public class HelpRepository: BaseRepository, HelpRepositoryProtocol {

    public func storeFeedback(investorId: Int, message: String) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        let api: HelpApi = .storeFeedback(investorId: investorId, message: message)
        return manager.request(api: api)
    }
    
}
