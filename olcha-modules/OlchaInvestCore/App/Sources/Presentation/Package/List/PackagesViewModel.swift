//
//  PackagesViewModel.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 24/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaUI
import Foundation
import OlchaCore

public class PackagesViewModel: BaseViewModel {
    
    @Published public var packages: LoadingState<InvestmentData, BaseErrorType> = .standart
    @Published public var package: LoadingState<InvestmentModel, BaseErrorType> = .standart
    
    private let loadPackagesUseCase: LoadPackagesProtocol
    private let loadPackageUseCase: LoadPackageProtocol
    
    public init(
        loadPackagesUseCase: LoadPackagesProtocol,
        loadPackageUseCase: LoadPackageProtocol
    ) {
        self.loadPackagesUseCase = loadPackagesUseCase
        self.loadPackageUseCase = loadPackageUseCase
    }
    
    func loadPackages(page: Int) {
        guard packages != .loading else { return }
        packages = .loading
        loadPackagesUseCase.execute(page: page)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    packages = .success(baseResponse.response)
                default:
                    packages = .failure(.init(message: baseResponse.error))
                    break
                }
            }.store(in: &bag)
    }
    
    func loadPackage(id: Int) {
        guard package != .loading else { return }
        package = .loading
        loadPackageUseCase.execute(id: id)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    package = .success(baseResponse.response)
                default:
                    package = .failure(.init(message: baseResponse.error))
                    break
                }
            }.store(in: &bag)
    }
}
