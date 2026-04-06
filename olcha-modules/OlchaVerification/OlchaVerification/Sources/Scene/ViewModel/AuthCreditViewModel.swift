//
//  AuthCreditViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/04/23.
//

import Foundation
import OlchaAuth
import OlchaUI
import OlchaCore
public class AuthCreditViewModel: BaseViewModel {
    
    @Published public var isVerified: LoadingState<EmptyData, BaseErrorType> = .standart
    
    private let creditIsVerifiedUseCase: CreditIsVerifiedProtocol
    
    public init(creditIsVerifiedUseCase: CreditIsVerifiedProtocol) {
        self.creditIsVerifiedUseCase = creditIsVerifiedUseCase
    }
      
    public func verifyCredit(completion: (() -> Void)? = nil) {
        guard AuthGlobalDefaults.isUser() else {
            AuthGlobalDefaults.user.isVerified = false
            return
        }
        guard isVerified != .loading else {
            return
        }
        
        isVerified = .loading
        
        creditIsVerifiedUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    AuthGlobalDefaults.user.isVerified = baseResponse.response?.is_verified ?? false
                    isVerified = .success(.init())
                default:
                    isVerified = .failure(.init(message: baseResponse.error))
                }
                isVerified = .standart
                completion?()
            }.store(in: &bag)
    }
}
