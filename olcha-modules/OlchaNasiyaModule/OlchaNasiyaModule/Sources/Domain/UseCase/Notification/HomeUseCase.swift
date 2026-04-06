//
//  NotificationUseCase.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 12/05/23.
//
import Combine
import OlchaCore
import Foundation

public protocol LoadLimitProtocol {
    func execute() -> AnyPublisher<BaseResponse<InstallmentLimitBalanceData, EmptyData>, Never>
}

public protocol RequestLimitProtocol {
    func execute() -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}


public enum HomeUseCase {
    
    
    public class LoadLimit: LoadLimitProtocol {
        
        private let repository: NasiyaHomeRepositoryProtocol
        
        public init(repository: NasiyaHomeRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<OlchaCore.BaseResponse<InstallmentLimitBalanceData, OlchaCore.EmptyData>, Never> {
            repository.loadLimit()
        }
    }
    
    public class RequestLimit: RequestLimitProtocol {
        
        private let repository: NasiyaHomeRepositoryProtocol
        
        public init(repository: NasiyaHomeRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<OlchaCore.BaseResponse<EmptyData, OlchaCore.EmptyData>, Never> {
            repository.requestLimit()
        }
    }
    
}
