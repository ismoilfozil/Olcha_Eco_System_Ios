//
//  ProfileUseCase.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 23/05/23.
//
import Foundation
import OlchaCore
import Combine

public protocol LoadProfileProtocol {
    func execute() -> AnyPublisher<BaseResponse<NasiyaUserData, EmptyData>, Never>
}

public protocol EditProfileProtocol {
    func execute(user: NasiyaUser) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}


public enum ProfileUseCase {
    
    public class LoadProfile: LoadProfileProtocol {
        
        private let repository: ProfileRepositoryProtocol
        
        public init(repository: ProfileRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<NasiyaUserData, EmptyData>, Never> {
            repository.loadUser()
        }
    }
    
    public class EditProfile: EditProfileProtocol {
        
        private let repository: ProfileRepositoryProtocol
        
        public init(repository: ProfileRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(user: NasiyaUser) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            repository.editUser(user: user)
        }
    }
    
}
