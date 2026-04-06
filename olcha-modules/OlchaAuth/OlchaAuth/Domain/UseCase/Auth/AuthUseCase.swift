//
//  AuthUseCase.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 09/08/23.
//

import Foundation
import Combine
import OlchaCore

public protocol GetUserTokenProtocol {
    func execute() -> AnyPublisher<BaseResponse<TokenModel, EmptyData>, Never>
}

public protocol GetGuestTokenProtocol {
    func execute() -> AnyPublisher<BaseResponse<TokenModel, EmptyData>, Never>
}

public protocol GetRefreshTokenProtocol {
    func execute() -> AnyPublisher<BaseResponse<TokenModel, EmptyData>, Never>
}

public protocol StoreUserDeviceProtocol {
    func execute(model: UserDevice) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public protocol DeleteUserDeviceProtocol {
    func execute(token: String) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public enum AuthUseCase {
    public class GetUserToken: GetUserTokenProtocol {
        private let repository: AuthRepositoryProtocol
        public init(repository: AuthRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<TokenModel, EmptyData>, Never> {
            repository.getUserToken()
        }
    }

    public class GetGuestToken: GetGuestTokenProtocol {
        private let repository: AuthRepositoryProtocol
        public init(repository: AuthRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<TokenModel, EmptyData>, Never> {
            repository.getGuestToken()
        }
    }

    public class GetRefreshToken: GetRefreshTokenProtocol {
        private let repository: AuthRepositoryProtocol
        public init(repository: AuthRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<TokenModel, EmptyData>, Never> {
            repository.refreshAuth()
        }
    }

    public class StoreUserDevice: StoreUserDeviceProtocol {
        private let repository: AuthRepositoryProtocol
        
        public init(repository: AuthRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(model: UserDevice) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            repository.storeUserDevice(model: model)
        }
    }
    
    public class DeleteUserDevice: DeleteUserDeviceProtocol {
        private let repository: AuthRepositoryProtocol
        
        public init(repository: AuthRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(token: String) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            repository.deleteUserDevice(token: token)
        }
    }
}
