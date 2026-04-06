//
//  InstallmentUseCase.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import Foundation
import OlchaCore
import Combine
public protocol LoadInstallmentsProtocol {
    func execute(filter: InstallmentFilter, cancel: Bool) -> AnyPublisher<BaseResponse<InstallmentsData, EmptyData>, Never>
}

public protocol LoadInstallmentProtocol {
    func execute(id: Int) -> AnyPublisher<BaseResponse<InstallmentData, EmptyData>, Never>
}

public enum InstallmentUseCase {
    public class LoadInstallments: LoadInstallmentsProtocol {
        
        private let repository: InstallmentRepositoryProtocol
        
        public init(repository: InstallmentRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(filter: InstallmentFilter, cancel: Bool) -> AnyPublisher<BaseResponse<InstallmentsData, EmptyData>, Never> {
            repository.loadInstallments(filter: filter, cancel: cancel)
        }
    }
    
    public class LoadInstallment: LoadInstallmentProtocol {
        
        private let repository: InstallmentRepositoryProtocol
        
        public init(repository: InstallmentRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(id: Int) -> AnyPublisher<BaseResponse<InstallmentData, EmptyData>, Never> {
            repository.loadInstallment(id: id)
        }
    }
}
