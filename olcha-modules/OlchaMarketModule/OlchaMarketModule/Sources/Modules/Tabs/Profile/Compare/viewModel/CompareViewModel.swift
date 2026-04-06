//
//  CompareViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/08/22.
//

import Foundation
import Combine
import OlchaUI
import OlchaAuth
import OlchaCore

//class CompareViewModel: OldBaseViewModel {
//
//    private var bag = Set<AnyCancellable>()
//    private let repository: CompareRepositoryProtocol
//
//    @Published var compareProducts: [ProductModel] = []
//    @Published var featuresData: CompareFeaturesData?
//    @Published var removedProduct: Bool = false
//    @Published var addedProduct: Bool = false
//
//    @Published var compareProduct: (product: ProductModel?, isAdded: Bool)?
//
//    static let shared = CompareViewModel()
//
//    init() {
//        repository = LocalCompareRepository()
//        super.init(manager: OlchaDIContainer.shared.resolve())
//    }
//
//    func addToCompare(product: ProductModel?) {
//        compareProduct = (product, true)
//        repository.addCompare(product: product).sink { baseResponse in
//            OlchaGlobalDefaults.compare_key = baseResponse.response?.comparison_key
//        }.store(in: &bag)
//
//    }
//
//    func removeCompare(product: ProductModel?) {
//        compareProduct = (product, false)
//        repository.removeCompare(product: product).sink { baseResponse in
//            OlchaGlobalDefaults.compare_key = baseResponse.response?.comparison_key
//        }.store(in: &bag)
//
//    }
//
//    func removeCompare(category: CategoryModel?) {
//
//        repository.removeCompare(category: category).sink { _ in }.store(in: &bag)
//
//    }
//
//    func loadCompareProducts() {
//
//        centerLoading = true
//        repository.loadCompareProducts().sink { [weak self] baseResponse in
//            guard let self else { return }
//            OlchaGlobalDefaults.compare_key = baseResponse.response?.comparison_key
//            compareProducts = baseResponse.response?.products ?? []
//            centerLoading = false
//        }.store(in: &bag)
//
//    }
//
//    func loadCompareProductFeatures(products: [ProductModel]) {
//        centerLoading = true
//        let api: CompareAPI = .compareOptions(products: products)
//        self.startRequesting(api: api) { [weak self] (data: CompareFeaturesData?) in
//            guard let self = self else { return }
//            var mockData = data
//
//            let swappedProducts = self.checkProductsOrder(products: products,
//                                                          swappingProducts: mockData?.products ?? [])
//            mockData?.products = swappedProducts
//
//            self.featuresData = mockData
//            self.centerLoading = false
//        }
//    }
//
//
//    func isAddedToCompare(product: ProductModel?) {
//
//        repository.isAddedCompare(product: product).sink { [weak self] baseResponse in
//            guard let self else { return }
//            addedProduct = baseResponse.response?.isCompleted ?? false
//        }.store(in: &bag)
//
//    }
//
//    private func checkProductsOrder(products: [ProductModel], swappingProducts: [ProductModel]) -> [ProductModel] {
//        var mockProducts = swappingProducts
//        if products.first?.id != swappingProducts.first?.id {
//            if !(swappingProducts.isEmpty) {
//                mockProducts.swapAt(0, (mockProducts.count - 1))
//            }
//        }
//        return mockProducts
//    }
//
//}

class CompareViewModel:  OldBaseViewModel {
    
    private var bag = Set<AnyCancellable>()
    private let repository: CompareRepositoryProtocol
    static let shared = CompareViewModel()
    
    @Published var comparedProducts: [ProductModel]?
    @Published var compareProduct: (product: ProductModel?, isAdded: Bool)?
    @Published var featuresData: CompareFeaturesData?
    
    let compareAdded = PassthroughSubject<Bool, Never>()
    
    init() {
        repository = RemoteCompareRepository()
        super.init(manager: OlchaDIContainer.shared.resolve())
    }
    
    func mergeCompare() {
        repository.mergeCompare().sink { [weak self] baseResponse in
            guard let self else { return }
            getCompareData(baseResponse.response)
        }.store(in: &bag)
    }
    
    func loadCompareProducts() {
        repository.loadCompareProducts().sink { [weak self] baseResponse in
            guard let self else { return }
            let data = baseResponse.response
            comparedProducts = data?.products ?? []
        }.store(in: &bag)
        
    }
    
    func addToCompare(product: ProductModel?) {
        compareProduct = (product, true)
        compareAdded.send(true)
        repository.addCompare(product: product)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                getCompareData(baseResponse.response)
            }.store(in: &bag)
    }
    
    func removeCompare(product: ProductModel?) {
        compareProduct = (product, false)
        repository.removeCompare(product: product)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                getCompareData(baseResponse.response)
            }.store(in: &bag)
    }
    
    func removeCompare(category: CategoryModel?, products: [ProductModel]) {
        for product in products {
            compareProduct = (product, false)
        }
        repository.removeCompare(category: category).sink { [weak self] baseResponse in
            guard let self else { return }
            getCompareData(baseResponse.response)
        }.store(in: &bag)
    }
    
    func loadCompareProductFeatures(products: [ProductModel]) {
        
        let api: CompareAPI = .compareOptions(products: products)
        self.startRequesting(api: api, isCancellable: true) { [weak self] (data: CompareFeaturesData?) in
            guard let self = self else { return }
            var mockData = data
            
            let swappedProducts = self.checkProductsOrder(products: products,
                                                          swappingProducts: mockData?.products ?? [])
            mockData?.products = swappedProducts
            
            self.featuresData = mockData
        }
    }
    
    private func checkProductsOrder(products: [ProductModel], swappingProducts: [ProductModel]) -> [ProductModel] {
        var mockProducts = swappingProducts
        if products.first?.id != swappingProducts.first?.id {
            if !(swappingProducts.isEmpty) {
                mockProducts.swapAt(0, (mockProducts.count - 1))
            }
        }
        return mockProducts
    }
    
    @discardableResult
    private func getCompareData(_ data: CompareData?) -> CompareData? {
        OlchaGlobalDefaults.compare_key = data?.comparison_key
        return data
    }
    
}

