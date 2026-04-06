//
//  LoyaltyViewModel.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 06/07/24.
//

import Foundation
import OlchaUI
import OlchaCore
import Combine
import OlchaAuth

public class LoyaltyViewModel: BaseViewModel {
    
    struct UseCase {
        let loadNextLevel: LoadLoyaltyNextLevelProtocol
        let loadLevels: LoadLoyaltyLevelsProtocol
        let loadUserLevel: LoadLoyaltyUserLevelProtocol
    }
    
    private let useCase: UseCase
    
    @Published public var nextLevel: LoadingState<LoyaltyNextLevelModel, BaseErrorType> = .standart
    @Published public var userLevel: LoadingState<LoyaltyUserLevelModel, BaseErrorType> = .standart
    @Published public var levels: LoadingState<LoyaltyLevelsModel, BaseErrorType> = .standart
    
    init(useCase: UseCase) {
        self.useCase = useCase
    }
    
    public func loadNextLevel() {
        
        guard AuthGlobalDefaults.isUser() else { return }
        
        useCase.loadNextLevel.execute()
            .sink { [weak self] baseResponse in
                guard let self else { return }
                 
                switch baseResponse.status {
                case .success:
                    LoyaltyManager.shared.mustShowNextLevel = true
                default:
                    break
                }
            }.store(in: &bag)
    }
    
    public func loadLevels() {
        
        guard AuthGlobalDefaults.isUser() else { return }
        
        useCase.loadLevels.execute()
            .sink { [weak self] baseResponse in
                guard let self else { return }
                
                switch baseResponse.status {
                case .success:
                    levels = .success(baseResponse.response)
                default:
                    levels = .failure(baseResponse.baseError)
                }
            }.store(in: &bag)
    }
    
    public func loadUserLevel() {
        
        guard AuthGlobalDefaults.isUser() else { return }
        
        useCase.loadUserLevel.execute()
            .sink { [weak self] baseResponse in
                guard let self else { return }
                  
                switch baseResponse.status {
                case .success:
                    userLevel = .success(baseResponse.response)
                default:
                    userLevel = .failure(baseResponse.baseError)
                }
            }.store(in: &bag)
    }
}
