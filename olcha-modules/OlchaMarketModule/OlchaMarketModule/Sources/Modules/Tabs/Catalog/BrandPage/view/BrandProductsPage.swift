//
//  BrandProductsPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 31/08/22.
//

import UIKit
import Combine
import OlchaUI
import SkeletonView
class BrandProductsPage: ProductsListPage {
    
    let manager = BrandLayoutManager()
    
    let brandViewModel = BrandPageViewModel()
    
    enum Section: Int {
        case sliders
        case bigBanner
        case flagmans
        case bestseller
        case products
    }
    
    lazy var bestSellerFilters : ProductListFilters = {
        let filters = ProductListFilters()
        filters.selectedSort = .popular
        filters.selectedManufacturer = self.filters.manufacturers.first
        return filters
    }()
    
    let bestsellerSkeleton = Skeleton(count: 3)
    
    let pushSliderObserver = PassthroughSubject<Slider?, Never>()
    
    var bigBanner: Slider?
    
    var flagmans: [Slider] = []
    
    var sliders: [Slider] = []
    
    var bestseller: ProductsData?
    
    weak var brandCoordinator: BrandsCoordinatorProtocol?
    
    func brandSections() -> [Section] {
        return [
            .sliders,
            .bigBanner,
            .flagmans,
            .bestseller,
            .products
       ]
    }
    
    override func configureViews() {
        
        navigation.setTitle(filters.manufacturers.first?.getName() ?? "")
        if filters.selectedSort == .none {
            filters.selectedSort = .popular
        }
        
        collection.registerClass(forCell: BannersRoom.self)
        collection.registerClass(forCell: BigBannerCell.self)
        collection.registerClass(forCell: PromotedCollectionRoom.self)
        collection.registerClass(forCell: BannerItem.self)
        collection.registerClass(forCell: ProductCell.self)
        collection.registerClass(forCell: ComponentCollectionHeader.self)
        
        super.configureViews()
    }
    
    override func setupObservers() {
        super.setupObservers()
        
        catalogViewModel
            .$categories
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.filters.category = CategoryModel.allCategory(categories: data?.categories)
                self.filters.catalogStack = [CategoryModel.allCategory(categories: data?.categories)]
                self.collection.reloadData()
            }.store(in: &bag)
        
        
        catalogViewModel
            .$popular
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.bestseller = data
                self.collection.reloadData()
            }.store(in: &bag)
        
        brandViewModel
            .$sliders
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                
                self.bigBanner = data?.sidebar_banner
                self.flagmans = data?.flagmans ?? []
                self.sliders = data?.sliders ?? []
                self.collection.reloadData()
            }.store(in: &bag)
        
        catalogViewModel
            .filterProductsIndicator
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                self.bestsellerSkeleton.isAnimating = isLoading
            }.store(in: &bag)
 
        pushSliderObserver.sink { [weak self] slider in
            guard let self else { return }
            brandCoordinator?.pushSlider(slider)
        }.store(in: &bag)
    }
    
    public override func categoryObserver() {
        filters
            .observers
            .openCategoryFilter
            .sink { [weak self] canOpen in
                guard let self = self else { return }
                if canOpen {
                    self.coordinator?.presentCategoryListForManufacturer(filters: self.filters)
                }
            }.store(in: &bag)
    }
    
    override func initialRequest() {
        super.initialRequest()
        
        catalogViewModel.loadProducts(with: .popular, filters: bestSellerFilters)
        catalogViewModel.loadCategories(manufacturer: filters.staticManufacturer?.getAlias())
        guard let slug = filters.manufacturers.first?.id else {
            return
        }
        
        brandViewModel.loadBrandSliders(with: "\(slug)")
    }
    
    override func getLayout() -> UICollectionViewLayout? {
        return manager.getLayout(
            with: .products(
                type: filters.cellType,
                tagsEmpty: filters.tags.isEmpty)
        )
    }
    
    override func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch brandSections()[indexPath.section] {
        case .sliders:
            return BannersRoom.classIdentifier
        case .bigBanner:
            return BigBannerCell.classIdentifier
        case .flagmans:
            return BannerItem.classIdentifier
        case .bestseller:
            return PromotedCollectionRoom.classIdentifier
        case .products:
            return ProductCell.classIdentifier
        }
    }
}
