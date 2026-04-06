//
//  SearchPageViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/10/22.
//

import Foundation
import Combine
import OlchaUI
import OlchaAuth
import OlchaCore
enum SearchType {
    case products
    case brand
    case category
}
enum SearchState {
    case loaded
    case loading
    case notFilled
}
class SearchPageViewModel: OldBaseViewModel, ObservableObject {
    
    private var timer: Timer?
    
    private var request: SearchRequest?
    
    @Published var products: [ProductModel]?
    @Published var brands: [Manufacturer]?
    @Published var categories: [CategoryModel]?
    
    @Published var searchState: SearchState = .notFilled
    
    var isLoading: [SearchType: Bool] = [
        .category: false,
        .brand: false,
        .products: false
    ]
    
    init() {
        super.init(manager: OlchaDIContainer.shared.resolve())
    }
    
    func search(text: String?, forcedSearch: Bool = false) {
        
        guard let text = text,
              text.count > 2 else {
            categories = []
            brands = []
            products = []
            timer?.invalidate()
            searchState = .notFilled
            return
        }
        searchState = .loading
        timer?.invalidate()
        request = .init(query: text)
        timer = Timer.scheduledTimer(timeInterval: forcedSearch ? 0 : 1.0,
                                     target: self,
                                     selector: #selector(startSearching),
                                     userInfo: nil,
                                     repeats: false);
        
    }
    
    @objc private func startSearching() {
        categories = []
        brands = []
        products = []
        searchState = .loading
        resetLoading()
        searchCategories()
        searchBrands()
        searchProducts()
    }
    
    private func searchCategories() {
        guard let request = request else { return }
        
        let api: SearchAPI = .categories(model: request)
        
        self.startRequesting(api: api,
                             isCancellable: true,
                             isSingleRequest: true,
                             centerLoader: true
        ) { [weak self] (data: SearchModel?) in
            guard let self = self else { return }
            checkLoading(type: .category)
            if let message = data?.message {
                self.show(error: message)
                FirebaseLogger.otherlog(message: message, api: api)
            } else {
                self.categories = data?.category?.compactMap { $0._source }
            }
        }
    }
    
    private func searchBrands() {
        guard let request = request else { return }
        
        let api: SearchAPI = .brands(model: request)
        
        self.startRequesting(api: api,
                             isCancellable: true,
                             isSingleRequest: true,
                             centerLoader: true) { [weak self] (data: SearchModel?) in
            guard let self = self else { return }
            checkLoading(type: .brand)
            if let message = data?.message {
                self.show(error: message)
                FirebaseLogger.otherlog(message: message, api: api)
            } else {
                self.brands = data?.brands?.compactMap { $0._source }
            }
        }
    }
    
    private func searchProducts() {
        guard let request = request else { return }
        
        let api: SearchAPI = .products(model: request)
        
        self.startRequesting(api: api,
                             isCancellable: true,
                             isSingleRequest: true,
                             centerLoader: true) { [weak self] (data: SearchModel?) in
            guard let self = self else { return }
            checkLoading(type: .products)
            if let message = data?.message {
                self.show(error: message)
                FirebaseLogger.otherlog(message: message, api: api)
            } else {
                self.products = data?.products?.compactMap { $0._source }
            }
        }
    }
    
    private func resetLoading() {
        isLoading[.category] = false
        isLoading[.brand] = false
        isLoading[.products] = false
    }
    
    private func checkLoading(type: SearchType) {
        isLoading[type] = true
        if isLoading.allSatisfy({ $1 == true }) {
            searchState = .loaded
        }
    }
}
	
