//
//  ProfileUseCase.swift
//  OlchaInvestModule
//
//  Created by Elbek Khasanov on 23/05/23.
//
import Foundation
import OlchaCore
import Combine

public protocol LoadProfileProtocol {
    func execute() -> AnyPublisher<BaseResponse<InvestUserData, EmptyData>, Never>
}

public protocol EditProfileProtocol {
    func execute(user: InvestUser) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}


public enum ProfileUseCase {
    
    public class LoadProfile: LoadProfileProtocol {
        
        private let repository: InvestProfileRepositoryProtocol
        
        public init(repository: InvestProfileRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<InvestUserData, EmptyData>, Never> {
            repository.loadUser()
        }
    }
    
    public class EditProfile: EditProfileProtocol {
        
        private let repository: InvestProfileRepositoryProtocol
        
        public init(repository: InvestProfileRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(user: InvestUser) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            repository.editUser(user: user)
        }
    }
    
}
