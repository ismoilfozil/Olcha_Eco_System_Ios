//
//  LoyaltyRepository.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 06/07/24.
//

import Foundation
import OlchaCore
import Combine

public protocol LoyaltyRepositoryProtocol {
    var api: LoyaltyAPIProtocol { get set }
    func nextLevel() -> AnyPublisher<BaseResponse<LoyaltyNextLevelModel, EmptyData>, Never>
    func getLevels() -> AnyPublisher<BaseResponse<LoyaltyLevelsModel, EmptyData>, Never>
    func getUserLevel() -> AnyPublisher<BaseResponse<LoyaltyUserLevelModel, EmptyData>, Never>
}

public class LoyaltyRepository: BaseRepository, LoyaltyRepositoryProtocol {
    
    public var api: LoyaltyAPIProtocol
    
    init(api: LoyaltyAPIProtocol, manager: NetworkManagerProtocol) {
        self.api = api
        super.init(manager: manager)
    }
    
    public func nextLevel() -> AnyPublisher<BaseResponse<LoyaltyNextLevelModel, EmptyData>, Never> {
        return manager.request(api: api.nextLevel())
    }
    
    public func getLevels() -> AnyPublisher<BaseResponse<LoyaltyLevelsModel, EmptyData>, Never> {
        return manager.request(api: api.getLevels())
    }
    
    public func getUserLevel() -> AnyPublisher<BaseResponse<LoyaltyUserLevelModel, EmptyData>, Never> {
        return manager.request(api: api.getUserLevel())
    }
}
