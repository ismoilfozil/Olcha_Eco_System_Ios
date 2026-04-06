//
//  VerificationUseCase.swift
//  OlchaVerification
//
//  Created by Elbek Khasanov on 27/06/23.
//

import Foundation
import Combine
import OlchaCore

public protocol LoadStepProtocol {
    func execute() -> AnyPublisher<BaseResponse<VerificationData, EmptyData>, Never>
}
public protocol UploadPassportImageProtocol {
    func execute(model: PassportModel, onCompletion: @escaping (BaseResponse<EmptyData, EmptyData>) -> Void)
}
public protocol LoadPassportProtocol {
    func execute() -> AnyPublisher<BaseResponse<DownloadedPassportData, EmptyData>, Never>
}
public protocol UploadPhonesProtocol {
    func execute(model: VerificationUploadPhonesModel) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}
public protocol LoadPhonesProtocol {
    func execute() -> AnyPublisher<BaseResponse<VerificationPhonesModel,EmptyData>, Never>
}
public protocol CreditIsVerifiedProtocol {
    func execute() -> AnyPublisher<BaseResponse<ValidatedData, EmptyData>, Never>
}

public enum VerificationUseCase {
    public class LoadStep: LoadStepProtocol {
        private let repository: VerificationRepositoryProtocol
        
        public init(repository: VerificationRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<VerificationData, EmptyData>, Never> {
            repository.loadStep()
        }
    }
    public class UploadPassportImage: UploadPassportImageProtocol {
        private let repository: VerificationRepositoryProtocol
        
        public init(repository: VerificationRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(model: PassportModel, onCompletion: @escaping (BaseResponse<EmptyData, EmptyData>) -> Void) {
            repository.uploadPassportImage(model: model, onCompletion: onCompletion)
        }
    }
    public class LoadPassport: LoadPassportProtocol {
        private let repository: VerificationRepositoryProtocol
        
        public init(repository: VerificationRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<DownloadedPassportData, EmptyData>, Never> {
            repository.loadPassport()
        }
    }
    public class UploadPhones: UploadPhonesProtocol {
        private let repository: VerificationRepositoryProtocol
        
        public init(repository: VerificationRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(model: VerificationUploadPhonesModel)  -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            repository.uploadPhones(model: model)
        }
    }
    public class LoadPhones: LoadPhonesProtocol {
        private let repository: VerificationRepositoryProtocol
        
        public init(repository: VerificationRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<VerificationPhonesModel,EmptyData>, Never> {
            repository.loadPhones()
        }
    }
    public class CreditIsVerified: CreditIsVerifiedProtocol {
        private let repository: VerificationRepositoryProtocol
        
        public init(repository: VerificationRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<ValidatedData, EmptyData>, Never> {
            repository.creditIsVerified()
        }
    }
}
