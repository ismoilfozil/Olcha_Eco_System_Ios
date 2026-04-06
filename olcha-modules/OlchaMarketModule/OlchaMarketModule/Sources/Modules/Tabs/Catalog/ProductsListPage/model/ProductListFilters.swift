//
//  Filters.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 14/07/22.
//

import Foundation
import Combine
import OlchaUtils
import OlchaCore
class ProductListPrice: Copying {
    
    static let MAX_CONSTS: Int = 100_000_000
    static let MIN_CONSTS: Int = 0
    
    var min: Int?
    var max: Int?
    
    init(min: Int? = nil, max: Int? = nil) {
        self.min = min
        self.max = max
    }
    
    required init(instance: ProductListPrice) {
        self.min = instance.min
        self.max = instance.max
    }
}
class ProductListObservers {
    let loadProductsObserver = PassthroughSubject<Bool, Never>()
    let openPriceFilter = PassthroughSubject<Bool, Never>()
    let openManufacturersFilter = PassthroughSubject<Bool, Never>()
    let openCategoryFilter = PassthroughSubject<Bool, Never>()
    let openFeatureFilter = PassthroughSubject<Int, Never>()//index
    
    let categoryUpdated = PassthroughSubject<Bool, Never>()
    
    let filterSelected = PassthroughSubject<Bool, Never>()
    let manufacturerSelected = PassthroughSubject<Bool, Never>()
    let tagSelected = PassthroughSubject<Bool, Never>()
}

enum ProductsType: Equatable {
    case often_needed
    case is_sale
    case popular
    case has_installment
    case is_new
    case has_discount
    case daily
    case none
    
    var type: String {
        switch self {
        case .often_needed:
            return "often_needed"
        case .is_sale:
            return "is_sale"
        case .has_discount:
            return "has_discount"
        case .popular:
            return "popular"
        case .has_installment:
            return "has_installment"
        case .is_new:
            return "is_new"
        case .daily:
            return "daily"
        case .none:
            return ""
        }
    }
}


enum ProductSimilarity: String {
    case analog
    case similar
    case alsoSeen
    case none
}

public class ProductListFilters: Copying {
    var navigationTitle: String {
        if category != nil {
            return category?.getName() ?? ""
        }
        
        if !stores.isEmpty {
            return stores.first?.getName() ?? ""
        }
        
        if search != "" {
            return search
        }
        
        return ""
    }
    var alias: String = ""
    var similarity: ProductSimilarity = .none
    var productsType: ProductsType = .none
    var route: String = ""
    var search: String = ""
    var queryRoute: String = ""
    
    var selectedSort: ProductsSortItem = .none
    
    
    var paging = Paging().perPage(30)
    var cellType : ProductCell.CellType = .shrink
    
    var filterPrice = ProductListPrice()
    var category: CategoryModel?
    var catalogStack: [CategoryModel] = []
    var features: [FeatureData] = []
    var tags: [TagModel] = []
    var stores: [Store] = []
    var staticManufacturer: Manufacturer?
    var manufacturers: [Manufacturer] = []
    
    var observers = ProductListObservers()
    var selectedManufacturer: Manufacturer? = nil {
        didSet {
            manufacturerSelected()
        }
    }
    
    var discountID: Int?
    
    public init() {}
    
    public required init(instance: ProductListFilters) {
        self.alias = instance.alias
        self.similarity = instance.similarity
        self.selectedSort = instance.selectedSort
        self.paging = instance.paging
        self.cellType = instance.cellType
        self.filterPrice = instance.filterPrice.copy()
        self.category = instance.category
        self.features = instance.features
        self.tags = instance.tags
        self.observers = instance.observers
        self.manufacturers = instance.manufacturers
        self.catalogStack = instance.catalogStack
        self.route = instance.route
        self.discountID = instance.discountID
    }
    
    func resetAllFilters() {
        self.paging = Paging().perPage(30)
        self.filterPrice = .init()
        self.features = []
        self.manufacturers = []
        self.tags = []
    }
    
    func resetAllSelectedFeatures() {
        self.filterPrice = ProductListPrice()
        for i in 0..<features.count {
            for k in 0..<(features[i].values?.count ?? 0) {
                features[i].values?[k].isSelected = false
                features[i].values?[k].isEnabled = true
            }
        }
        
        for i in 0..<manufacturers.count {
            manufacturers[i].isSelected = false
            manufacturers[i].isEnabled = true
        }
        
        for i in 0..<tags.count {
            tags[i].isSelected = false
            tags[i].isEnabled = true
        }
    }
    
    func resetPrices() {
        self.filterPrice = ProductListPrice()
    }
    
    func resetSelectedFeatures(with index: Int) {
        for i in 0..<(features[index].values?.count ?? 0) {
            features[index].values?[i].isSelected = false
        }
    }
    
    func resetSelectedManufacturers() {
        for i in 0..<manufacturers.count {
            manufacturers[i].isSelected = false
        }
    }
    
    enum FilterType {
        case tag
        case features
        case none
    }
    
    func featureSelected(type: FilterType) {
        switch type {
        case .tag:
            for i in 0..<features.count {
                for k in 0..<(features[i].values?.count ?? 0) {
                    features[i].values?[k].isSelected = false
                    features[i].values?[k].isEnabled = true
                }
            }
            
            for i in 0..<manufacturers.count {
                manufacturers[i].isSelected = false
                manufacturers[i].isEnabled = true
            }
            break
        case .features:
            for i in 0..<tags.count {
                tags[i].isSelected = false
                tags[i].isEnabled = true
            }
            break
        case .none:
            break
        }
    }
    
    func manufacturerSelected() {
        if var newManufacturer = selectedManufacturer {
            newManufacturer.isSelected = true
            
            if newManufacturer.isEnabled == nil {
                newManufacturer.isEnabled = true
            }
            
            manufacturers = [newManufacturer]
            selectedManufacturer = nil
        }
    }
    
    func setManufacturers(oldValues: [Manufacturer], newValues: [Manufacturer]) {
        var newMockValues = newValues
        for i in 0..<newValues.count {
            oldValues.forEach {
                if ($0.id == newMockValues[i].id || $0.slug == newMockValues[i].slug) && ($0.isEnabled ?? true) && ($0.isSelected ?? false) {
                    newMockValues[i].isSelected = true
                }
            }
        }
        self.manufacturers = newMockValues
    }
    
    @discardableResult
    func setStaticManufacturer(_ manufacturer: Manufacturer) -> Self {
        var modifiedBrand = manufacturer
        modifiedBrand.isEnabled = true
        modifiedBrand.isSelected = true
        manufacturers = [modifiedBrand]
        staticManufacturer = modifiedBrand
        return self
    }
}
