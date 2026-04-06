//
//  CompareRepository.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/08/22.
//

import UIKit
import CoreData
import Combine
import OlchaCore
protocol CompareRepositoryProtocol: AnyObject {
    
    func addCompare(product: ProductModel?) -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never>
    
    func removeCompare(product: ProductModel?) -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never>
    
    func removeCompare(category: CategoryModel?) -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never>
    
    func loadCompareProducts() -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never>
    
    func loadCompareProducts(with category: CategoryModel?) -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never>
    
    func loadCategories() -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never>
    
    func isAddedCompare(product: ProductModel?) -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never>
    
    func mergeCompare() -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never>
}

class LocalCompareRepository: CompareRepositoryProtocol {
    
    private var manager: CompareManager?
    
    init() {
        let context = StorageContainer.shared.persistentContainer.viewContext
        manager = CompareManager(context: context)
    }
    
    func addCompare(product: ProductModel?) -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never> {
        return Future { [weak self] promise in
            guard let self else { return }
            Task {
                let response = await self.manager?.addToCompare(product: product)
                promise(.success(BaseResponse(status: .success, response: CompareData(product: product))))
            }
        }.eraseToAnyPublisher()
    }
    
    func removeCompare(product: ProductModel?) -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never> {
        return Future { [weak self] promise in
            guard let self else { return }
            Task {
                let response = await self.manager?.removeCompare(product: product)
                promise(.success(BaseResponse(status: .success, response: CompareData(isCompleted: response))))
            }
        }.eraseToAnyPublisher()
    }
    
    func removeCompare(category: CategoryModel?) -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never> {
        return Future { [weak self] promise in
            guard let self else { return }
            Task {
                let response = await self.manager?.removeCompare(category: category)
                promise(.success(BaseResponse(status: .success, response: CompareData(isCompleted: response))))
            }
        }.eraseToAnyPublisher()
    }
    
    func loadCompareProducts() -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never> {
        return Future { [weak self] promise in
            guard let self else { return }
            Task {
                let response = await self.manager?.loadCompareProducts()
                promise(.success(BaseResponse(status: .success, response: CompareData(products: response))))
            }
        }.eraseToAnyPublisher()
    }
    
    func loadCompareProducts(with category: CategoryModel?) -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never> {
        return Future { promise in
            Task {
                let response: [ProductModel] = []
                promise(.success(BaseResponse(status: .success, response: CompareData(products: response))))
            }
        }.eraseToAnyPublisher()
    }

    func loadCategories() -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never> {
        return Future { promise in
            Task {
                let response: [CategoryModel] = []
                promise(.success(BaseResponse(status: .success, response: CompareData(categories: response))))
            }
        }.eraseToAnyPublisher()
    }
    
    func isAddedCompare(product: ProductModel?) -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never> {
        return Future { [weak self] promise in
            guard let self else { return }
            Task {
                let response = await self.manager?.isAddedCompare(product: product) ?? false
                promise(.success(BaseResponse(status: .success, response: CompareData(isCompleted: response))))
            }
        }.eraseToAnyPublisher()
    }
    
    func mergeCompare() -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never> {
        return Future { promise in
            promise(.success(BaseResponse(status: .success, response: CompareData())))
        }.eraseToAnyPublisher()
    }
}

class RemoteCompareRepository: CompareRepositoryProtocol {
    
    private var bag = Set<AnyCancellable>()
    private var manager: NetworkManagerProtocol
    
    init() {
        manager = OlchaDIContainer.shared.resolve()
    }
    
    func addCompare(product: ProductModel?) -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never> {
        let api: CompareAPI = .addCompare(product: product)
        return manager.request(api: api)
    }
    
    func removeCompare(product: ProductModel?) -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never> {
        let api: CompareAPI = .removeCompare(product: product)
        return manager.request(api: api)
    }
    
    func removeCompare(category: CategoryModel?) -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never> {
        let api: CompareAPI = .removeCompareFrom(category: category)
        return manager.request(api: api)
    }
    
    func loadCompareProducts() -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never> {
        let api: CompareAPI = .loadProducts
        return manager.request(api: api)
    }
    
    func loadCompareProducts(with category: CategoryModel?) -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never> {
        let api: CompareAPI = .loadCompareProducts(category: category)
        return manager.request(api: api)
    }
    
    func loadCategories() -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never> {
        let api: CompareAPI = .loadCategories
        return manager.request(api: api)
    }
    
    func isAddedCompare(product: ProductModel?) -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never> {
        return Future { promise in
            promise(.success(BaseResponse(status: .success, response: CompareData(isCompleted: product?.is_compared))))
        }.eraseToAnyPublisher()
    }
    
    func mergeCompare() -> AnyPublisher<BaseResponse<CompareData, EmptyData>, Never> {
        let api: CompareAPI = .mergeCompare
        return manager.request(api: api)
    }
}
