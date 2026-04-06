//
//  ProductViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/07/22.
//

import Foundation
import Combine
import OlchaUI
import OlchaCore
import OlchaAuth
class ProductViewModel: OldBaseViewModel {
    
    @Published var variationsData: LoadingState<Data, BaseErrorType> = .standart
    @Published var fullProduct: LoadingState<FullProductData, BaseErrorType> = .standart
    @Published var characteristicsData: LoadingState<CharacteristicsData, BaseErrorType> = .standart
    @Published var priceHistory: LoadingState<PriceHistoryData, BaseErrorType> = .standart
    
    let fullProductObserver = CurrentValueSubject<Bool, Never>(false)
    
    init() {
        super.init(manager: OlchaDIContainer.shared.resolve())
    }
    
    
    func loadProductCharacteristics(_ id: Int) {
        let api: ProductAPI = .characteristics(id: id)
        characteristicsData = .loading
        self.startRequesting(api: api) { [weak self] (data: CharacteristicsData?) in
            guard let self = self else { return }
            characteristicsData = .success(data)
        } onError: { [weak self] error in
            guard let self else { return }
            characteristicsData = .failure(.init(message: error))
        }
    }
    
    func loadVariations(productID: Int) {
        let api: ProductAPI = .variations(productID: productID)
        variationsData = .loading
        self.startDataRequesting(api: api) { [weak self] data in
            guard let self = self else { return }
            variationsData = .success(data)
        } onError: { [weak self] error in
            self?.variationsData = .failure(BaseErrorType(message: error))
        }
    }
    
    func loadVariations(productID: Int, storeID: Int) {
        let api: ProductAPI = .storeVariations(productID: productID,
                                               storeID: storeID)
        variationsData = .loading
        self.startDataRequesting(api: api) { [weak self] data in
            guard let self = self else { return }
            variationsData = .success(data)
        } onError: { [weak self] error in
            guard let self = self else { return }
            variationsData = .failure(BaseErrorType(message: error))
        }
    }
    
    func loadProductID(_ id: Int) {
        let api: ProductAPI = .productsID(id: id)
        fullProduct = .loading
        self.startRequesting(api: api,
                             isCancellable: true,
                             indicator: fullProductObserver
        ) { [weak self] (data: FullProductData?) in
            guard let self = self else { return }
            fullProduct = .success(data)
        } onError: { [weak self] error in
            guard let self = self else { return }
            fullProduct = .failure(BaseErrorType(message: error))
        }
    }
    
    func loadProductAlias(_ alias: String) {
        let api: ProductAPI = .productsAlias(alias: alias)
        fullProduct = .loading
        self.startRequesting(api: api,
                             isCancellable: true,
                             centerLoader: true,
                             indicator: fullProductObserver
        ) { [weak self] (data: FullProductData?) in
            guard let self = self else { return }
            fullProduct = .success(data)
        } onError: { [weak self] error in
            guard let self = self else { return }
            fullProduct = .failure(BaseErrorType(message: error))
        }
    }
    
    func loadProductPriceHistory(_ id: Int) {
        let api: ProductAPI = .priceHistory(id: id)
        priceHistory = .loading
        self.startRequesting(api: api) { [weak self] (data: PriceHistoryData?) in
            guard let self = self else { return }
            priceHistory = .success(data)
        } onError: { [weak self] error in
            guard let self = self else { return }
            priceHistory = .failure(BaseErrorType(message: error))
        }
    }
 }
