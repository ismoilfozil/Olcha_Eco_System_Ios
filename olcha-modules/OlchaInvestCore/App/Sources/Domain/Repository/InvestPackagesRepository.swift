//
//  InvestPackagesRepository.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 24/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaCore
import Combine

public protocol InvestPackagesRepositoryProtocol {
    func loadPackages(page: Int) -> AnyPublisher<BaseResponse<InvestmentData, EmptyData>, Never>
    func loadPackage(id: Int) -> AnyPublisher<BaseResponse<InvestmentModel, EmptyData>, Never>
    func loadTerms(termId: Int) -> AnyPublisher<BaseResponse<InvestmentData, EmptyData>, Never>
}

public class InvestPackagesRepository: BaseRepository, InvestPackagesRepositoryProtocol {
    public func loadPackages(page: Int) -> AnyPublisher<BaseResponse<InvestmentData, EmptyData>, Never> {
        let api: PackagesApi = .packages(page: page)
        return manager.request(api: api)
    }
    
    public func loadPackage(id: Int) -> AnyPublisher<BaseResponse<InvestmentModel, EmptyData>, Never> {
        let api: PackagesApi = .package(id: id)
        return manager.request(api: api)
    }
    
    public func loadTerms(termId: Int) -> AnyPublisher<BaseResponse<InvestmentData, EmptyData>, Never> {
        let api: PackagesApi = .term(id: termId)
        return manager.request(api: api)
    }
}

public class InvestPackagesMockRepository: InvestPackagesRepositoryProtocol {
    
    public func loadPackages(page: Int) -> AnyPublisher<BaseResponse<InvestmentData, EmptyData>, Never> {
        return Future { promise in
            promise(.success(
                BaseResponse(
                    status: .success,
                    error: nil,
                    response: InvestmentData.mock(page: page),
                    code: 200,
                    errors: nil
                )
            ))
        }.eraseToAnyPublisher()
    }
    
    public func loadPackage(id: Int) -> AnyPublisher<BaseResponse<InvestmentModel, EmptyData>, Never> {
        return Future { promise in
            promise(.success(
                BaseResponse(
                    status: .success,
                    error: nil,
                    response: InvestmentModel.mock(id: id),
                    code: 200,
                    errors: nil
                )
            ))
        }.eraseToAnyPublisher()
    }
    
    public func loadTerms(termId: Int) -> AnyPublisher<BaseResponse<InvestmentData, EmptyData>, Never> {
        return Future { promise in
            promise(.success(
                BaseResponse(
                    status: .success,
                    error: nil,
                    response: InvestmentData.mock(page: 1),
                    code: 200,
                    errors: nil
                )
            ))
        }.eraseToAnyPublisher()
    }
    
}
