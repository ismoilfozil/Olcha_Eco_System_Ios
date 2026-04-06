//
//  LoyaltyUseCase.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 06/07/24.
//

import Combine
import OlchaCore
import Foundation
import OlchaUtils

protocol LoadLoyaltyNextLevelProtocol {
    func execute() -> AnyPublisher<BaseResponse<LoyaltyNextLevelModel, EmptyData>, Never>
}
protocol LoadLoyaltyLevelsProtocol {
    func execute() -> AnyPublisher<BaseResponse<LoyaltyLevelsModel, EmptyData>, Never>
}
protocol LoadLoyaltyUserLevelProtocol {
    func execute() -> AnyPublisher<BaseResponse<LoyaltyUserLevelModel, EmptyData>, Never>
}

public enum LoyaltyUseCase {
    public struct LoadLoyaltyNextLevel: LoadLoyaltyNextLevelProtocol {
        let repository: LoyaltyRepositoryProtocol
        
        public func execute() -> AnyPublisher<BaseResponse<LoyaltyNextLevelModel, EmptyData>, Never> {
            repository.nextLevel()
        }
    }
    
    public struct LoadLoyaltyLevels: LoadLoyaltyLevelsProtocol {
        let repository: LoyaltyRepositoryProtocol
        
        public func execute() -> AnyPublisher<BaseResponse<LoyaltyLevelsModel, EmptyData>, Never> {
            repository.getLevels()
        }
    }
    
    public struct LoadLoyaltyUserLevel: LoadLoyaltyUserLevelProtocol {
        let repository: LoyaltyRepositoryProtocol
        
        public func execute() -> AnyPublisher<BaseResponse<LoyaltyUserLevelModel, EmptyData>, Never> {
            repository.getUserLevel()
        }
    }
    
}
