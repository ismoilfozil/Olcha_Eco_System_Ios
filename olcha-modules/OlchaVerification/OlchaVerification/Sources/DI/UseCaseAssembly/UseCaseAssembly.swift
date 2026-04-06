//
//  CoordinatorAssembly.swift
//  OlchaVerification
//
//  Created by Elbek Khasanov on 22/05/23.
//

import UIKit
import Swinject
final class UseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoadStepProtocol.self) { r in
            let repository = r.resolve(VerificationRepositoryProtocol.self)!
            return VerificationUseCase.LoadStep(repository: repository)
        }
        
        container.register(UploadPassportImageProtocol.self) { r in
            let repository = r.resolve(VerificationRepositoryProtocol.self)!
            return VerificationUseCase.UploadPassportImage(repository: repository)
        }
        
        container.register(LoadPassportProtocol.self) { r in
            let repository = r.resolve(VerificationRepositoryProtocol.self)!
            return VerificationUseCase.LoadPassport(repository: repository)
        }
        
        container.register(UploadPhonesProtocol.self) { r in
            let repository = r.resolve(VerificationRepositoryProtocol.self)!
            return VerificationUseCase.UploadPhones(repository: repository)
        }
        
        container.register(LoadPhonesProtocol.self) { r in
            let repository = r.resolve(VerificationRepositoryProtocol.self)!
            return VerificationUseCase.LoadPhones(repository: repository)
        }
        
        container.register(CreditIsVerifiedProtocol.self) { r in
            let repository = r.resolve(VerificationRepositoryProtocol.self)!
            return VerificationUseCase.CreditIsVerified(repository: repository)
        }
        
        container.register(CheckExistProtocol.self) {  r in
            let repository = r.resolve(MyIdRepositoryProtocol.self)!
            return MyIdUseCase.CheckExist(repository: repository)
        }
        
        container.register(UploadCodeProtocol.self) {  r in
            let repository = r.resolve(MyIdRepositoryProtocol.self)!
            return MyIdUseCase.UploadCode(repository: repository)
        }
    }
}
