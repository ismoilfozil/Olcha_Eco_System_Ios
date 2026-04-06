//
//  VerificationUseCase.swift
//  OlchaVerification
//
//  Created by Elbek Khasanov on 27/06/23.
//

import Foundation
import Combine
import OlchaCore

public protocol CheckExistProtocol {
    func execute(model: MyIdPassportModel) -> AnyPublisher<BaseResponse<MyIdExistModel, EmptyData>, Never>
}

public protocol UploadCodeProtocol {
    func execute(model:MyIdCodeModel) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}


public enum MyIdUseCase {
    
    public class CheckExist : CheckExistProtocol {
        
        private let repository: MyIdRepositoryProtocol
        
        public init(repository: MyIdRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(model: MyIdPassportModel) -> AnyPublisher<OlchaCore.BaseResponse<MyIdExistModel, OlchaCore.EmptyData>, Never> {
            repository.checkExist(model: model)
        }
    }
    
    
    public class UploadCode : UploadCodeProtocol {
       
        
        private let repository: MyIdRepositoryProtocol
        
        public init(repository: MyIdRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(model: MyIdCodeModel) -> AnyPublisher<OlchaCore.BaseResponse<OlchaCore.EmptyData, OlchaCore.EmptyData>, Never> {
            repository.uploadMyIdCode(model: model)
        }
        
    }
    
}
