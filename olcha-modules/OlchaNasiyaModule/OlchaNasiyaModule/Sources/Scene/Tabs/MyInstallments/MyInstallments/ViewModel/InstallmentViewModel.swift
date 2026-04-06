//
//  InstallmentViewModel.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import Foundation
import Combine
import OlchaUI
import OlchaCore
public class InstallmentViewModel: BaseViewModel {
    
    @Published public var installments: LoadingState<InstallmentsData, BaseErrorType> = .standart
    @Published public var installment: LoadingState<InstallmentModel, BaseErrorType> = .standart
    
    private let loadInstallmentsUseCase: LoadInstallmentsProtocol
    private let loadInstallmentUseCase: LoadInstallmentProtocol
    
    public init(loadInstallmentsUseCase: LoadInstallmentsProtocol,
                loadInstallmentUseCase: LoadInstallmentProtocol) {
        self.loadInstallmentsUseCase = loadInstallmentsUseCase
        self.loadInstallmentUseCase = loadInstallmentUseCase
    }
    
    public func loadInstallments(filter: InstallmentFilter, cancel: Bool = false) {
        guard installments != .loading else { return }
        installments = .loading
        loadInstallmentsUseCase.execute(filter: filter, cancel: cancel)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                
                switch baseResponse.status {
                case .success:
                    installments = .success(baseResponse.response)
                case .canceled: break
                default:
                    installments = .failure(.init(message: baseResponse.error))
                }
            }.store(in: &bag)
    }
    
    public func loadInstallment(id: Int?) {
        guard let id = id else { return }
        installment = .loading
        loadInstallmentUseCase.execute(id: id)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    installment = .success(baseResponse.response?.orders)
                default:
                    installment = .failure(
                        .init(message: baseResponse.error)
                    )
                }
            }.store(in: &bag)
    }
}
