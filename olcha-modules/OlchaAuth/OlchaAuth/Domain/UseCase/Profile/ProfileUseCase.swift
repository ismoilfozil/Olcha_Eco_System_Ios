//
//  ProfileUseCase.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 26/05/23.
//

import Foundation
import Combine
import OlchaCore

public protocol LoadUserDataProtocol {
    func execute() -> AnyPublisher<BaseResponse<UserData, EmptyData>, Never>
}

public protocol EditUserDataProtocol {
    func execute(model: User) -> AnyPublisher<BaseResponse<EmptyData, ValidationErrors>, Never>
}

public protocol DeleteUserProtocol {
    func execute() -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public enum ProfileUseCase {
    
    public class LoadProfileData: LoadUserDataProtocol {
        private let repository: ProfileRepositoryProtocol
        
        public init(repository: ProfileRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<UserData, EmptyData>, Never> {
            repository.loadUserData()
        }
    }
    
    public class EditUserData: EditUserDataProtocol {
        private let repository: ProfileRepositoryProtocol
        
        public init(repository: ProfileRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(model: User) -> AnyPublisher<BaseResponse<EmptyData, ValidationErrors>, Never> {
            repository.editUserData(model: model)
        }
    }
    
    public class DeleteUser: DeleteUserProtocol {
        private let repository: ProfileRepositoryProtocol
        
        public init(repository: ProfileRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            repository.deleteUser()
        }
    }
}
