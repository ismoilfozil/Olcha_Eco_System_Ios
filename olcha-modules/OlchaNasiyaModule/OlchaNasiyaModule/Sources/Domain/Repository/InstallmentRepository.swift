//
//  InstallmentRepository.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import Foundation
import OlchaCore
import OlchaAuth
import Combine
public protocol InstallmentRepositoryProtocol {
    func loadInstallments(filter: InstallmentFilter, cancel: Bool) -> AnyPublisher<BaseResponse<InstallmentsData, EmptyData>, Never>
    func loadInstallment(id: Int) -> AnyPublisher<BaseResponse<InstallmentData, EmptyData>, Never>
}

public class InstallmentRepository: BaseRepository, InstallmentRepositoryProtocol {
    
    public func loadInstallments(filter: InstallmentFilter, cancel: Bool) -> AnyPublisher<BaseResponse<InstallmentsData, EmptyData>, Never> {
        let api: InstallmentAPI = .installments(filter: filter)
        return manager.request(api: api, isCancellable: cancel)
    }
    
    public func loadInstallment(id: Int) -> AnyPublisher<BaseResponse<InstallmentData, EmptyData>, Never> {
        let api: InstallmentAPI = .installment(id: id)
        return manager.request(api: api)
    }
}

public class InstallmentMockRepository: InstallmentRepositoryProtocol {
    public func loadInstallments(filter: InstallmentFilter, cancel: Bool) -> AnyPublisher<BaseResponse<InstallmentsData, EmptyData>, Never> {
        return Future { promise in
            promise(.success(BaseResponse<InstallmentsData, EmptyData>(status: .success,
                                          error: nil,
                                                                       response: InstallmentsData.mock(page: filter.installments.paging.current,
                                                                                                       lastPage: filter.installments.paging.total
                                                                                        ),
                                          code: 200,
                                          errors: nil)))
        }.eraseToAnyPublisher()
    }
    
    public func loadInstallment(id: Int) -> AnyPublisher<BaseResponse<InstallmentData, EmptyData>, Never> {
        return Future { promise in
            promise(.success(BaseResponse<InstallmentData, EmptyData>(status: .success,
                                          error: nil,
                                                                response: InstallmentData.mock(id: id),
                                          code: 200,
                                          errors: nil)))
        }.eraseToAnyPublisher()
    }
}
