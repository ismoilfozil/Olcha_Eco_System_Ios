//
//  SelectTermViewModel.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaUI
import Foundation
import OlchaCore

public class SelectTermViewModel: BaseViewModel {
    
    @Published public var terms: LoadingState<InvestmentData, BaseErrorType> = .standart
    
    private let loadTermsUseCase: LoadTermsProtocol
    
    public init(loadTermsUseCase: LoadTermsProtocol) {
        self.loadTermsUseCase = loadTermsUseCase
    }
    
    func loadTerms(packageId: Int) {
        terms = .loading
        loadTermsUseCase.execute(termId: packageId)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    terms = .success(baseResponse.response)
                default:
                    terms = .failure(.init(message: baseResponse.error))
                    break
                }
            }.store(in: &bag)
    }
    
}
