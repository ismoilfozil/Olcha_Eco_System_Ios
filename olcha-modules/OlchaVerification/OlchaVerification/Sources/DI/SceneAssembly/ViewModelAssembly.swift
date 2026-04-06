//
//  OlchaVerificationViewModelAssembly.swift
//  OlchaVerification
//
//  Created by Elbek Khasanov on 21/05/23.
//

import Foundation
import OlchaAuth
import OlchaCore
import Swinject
final class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(VerificationViewModel.self) { r in
            
            let loadStepUseCase = r.resolve(LoadStepProtocol.self)!
            let uploadPassportImageUseCase = r.resolve(UploadPassportImageProtocol.self)!
            let loadPassportUseCase = r.resolve(LoadPassportProtocol.self)!
            let uploadPhonesUseCase = r.resolve(UploadPhonesProtocol.self)!
            let loadPhonesUseCase = r.resolve(LoadPhonesProtocol.self)!
            let checkExistUseCase = r.resolve(CheckExistProtocol.self)!
            let uploadCodeUseCase = r.resolve(UploadCodeProtocol.self)!
            
            return VerificationViewModel(loadStepUseCase: loadStepUseCase,
                                         uploadPassportImageUseCase: uploadPassportImageUseCase,
                                         loadPassportUseCase: loadPassportUseCase,
                                         uploadPhonesUseCase: uploadPhonesUseCase,
                                         loadPhonesUseCase: loadPhonesUseCase,
                                         checkExistUseCase: checkExistUseCase,
                                         uploadCodeUseCase: uploadCodeUseCase
            )
        }
        
        container.register(AuthCreditViewModel.self, name: .shared) { r in
            let creditIsVerifiedUseCase = r.resolve(CreditIsVerifiedProtocol.self)!
            return AuthCreditViewModel(creditIsVerifiedUseCase: creditIsVerifiedUseCase)
        }.inObjectScope(.container)
        
        container.register(AuthCreditViewModel.self) { r in
            let creditIsVerifiedUseCase = r.resolve(CreditIsVerifiedProtocol.self)!
            return AuthCreditViewModel(creditIsVerifiedUseCase: creditIsVerifiedUseCase)
        }
    }
}
