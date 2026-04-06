//
//  HelpViewModel.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaCore

public class HelpViewModel: BaseViewModel {
    
    @Published public var hasFeedbackSent: LoadingState<Bool, BaseErrorType> = .standart
    
    private let storeFeedbackUseCase: StoreFeedbackUseCaseProtocol
    
    public init(storeFeedbackUseCase: StoreFeedbackUseCaseProtocol) {
        self.storeFeedbackUseCase = storeFeedbackUseCase
    }
    
    public func storeFeedback(message: String) {
        guard hasFeedbackSent != .loading, let investorId = InvestGlobalDefaults.account.investorId else { return }
        hasFeedbackSent = .loading
        storeFeedbackUseCase.execute(investorId: investorId, message: message)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    hasFeedbackSent = .success(true)
                default:
                    hasFeedbackSent = .failure(.init(message: baseResponse.error))
                }
            }.store(in: &bag)
    }
    
}
