//
//  DetailedCatalogListPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 09/08/22.
//

import UIKit
import Combine
import SwiftUI
import OlchaUI
public class DetailedCatalogListPage: BaseViewController {
    
    public enum InitialPageState {
        case route(String)
        case categoryID(Int)
        case category(CategoryModel?, Manufacturer?)
        case none
    }

    public enum Section: Int {
        case categorySelect
        case banner
        case categories
        case popular
        case categoryProducts
        case brands
        case products
        case footer
        case none
    }
    
    var category: CategoryModel? {
        didSet {
            if category != oldValue {
                categoryUpdated()
            }
        }
    }
    
    let collection = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    private var bag = Set<AnyCancellable>()
    
    let viewModel = DetailedCatalogViewModel()
    
    var brand: Manufacturer?
    
    weak var coordinator: CatalogCoordinatorProtocol?
    
    let manager = DetailedCatalogLayoutManager()
    
    var sections: [Section] = [
        .categorySelect,
        .banner,
        .categories,
        .popular,
        .categoryProducts,
        .brands,
        .products,
        .footer
    ]
    
    let categoryProductsObserver = PassthroughSubject<(CategoryModel?, ProductsData?), Never>()
    let pushBrandObserver = PassthroughSubject<Manufacturer?, Never>()
    let pushAllBrandsObserver = PassthroughSubject<Bool, Never>()
    let pushSubcatalogObserver = PassthroughSubject<CategoryModel?, Never>()
    let pushAllProductObserver = PassthroughSubject<CategoryModel?, Never>()
    
    let pushCategoryObserver = PassthroughSubject<(CategoryModel?, Manufacturer?), Never>()
    let pushSliderObserver = PassthroughSubject<Slider?, Never>()
    let sortProductsIndicator = PassthroughSubject<Bool, Never>()
    
    let productHelper = ProductHelper()
    var pageState: InitialPageState = .none
    
    var helper = DetailedCatalogPaginator()
    
    //MARK: - lifecycle
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            if !(coordinator?.selectedCatalogStack.isEmpty ?? true) {
                coordinator?.selectedCatalogStack.removeLast()
            }
        }
    }
    
    var products: [ProductModel] = []
    
    let filters = ProductListFilters()
    
//    let productsSkeleton = Skeleton(count: 9)
    
    var layout: Composition?
    var header: ProductsListHeader?
    
    var lastY: CGFloat = 0
    var sectionHeader: ProductsListHeader?
    
    var isPinned = true
    var isAnimating = false
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(collection)
        setupSortMenus()
    }
    
    override func autolayout() {
        super.autolayout()
        collection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.configure(style: .back)
        filters.selectedSort = .popular
        
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forHeader: ProductsListHeader.self, kind: UICollectionView.elementKindSectionHeader)
        collection.registerClass(forHeader: EmptyHeader.self, kind: UICollectionView.elementKindSectionHeader)
        
        collection.registerClass(forCell: PromotedCollectionRoomWithHeader.self)
        collection.registerClass(forCell: ComponentCollectionHeader.self)
        collection.registerClass(forCell: CatalogSelectRoom.self)
        collection.registerClass(forCell: CatalogBannersRoom.self)
        collection.registerClass(forCell: BrandsCollectionRoom.self)
        collection.registerClass(forCell: ProductCell.self)
        collection.registerClass(forCell: BackgroundedImage.self)
        collection.registerClass(forCell: FooterCollectionItem.self)
        collection.registerClass(forCell: EmptyCell.self)
    }
    
    
    override func initialRequest() {
        super.initialRequest()
        switch pageState {
        case .route(let route):
            viewModel.loadCategory(route: route)
            break
        case .categoryID(let categoryID):
            viewModel.loadCategory(with: categoryID.string)
            break
        case .category(let category, let brand):
            self.brand = brand
            let alias = Funcs.getCategoryAlias(category: category)
            if alias != "" {
                viewModel.loadCategory(with: alias)
            }
        case .none:
            break
        }
    }
    
    private func categoryHelpRequest() {
        
        loadSliders()
        loadPopularProducts()
        
    }
    
    private func categoryUpdated() {
        navigation.setTitle(category?.getName() ?? "")
        helper.categories = category?.children ?? []
        helper.categoriesPaging.total = helper.categories.count
        helper.categoriesPaging.current = 0
        if let category = category {
            coordinator?.selectedCatalogStack.append(category)
        }
        helper.initialReloaded = false
        collection.initialState()
        categoryHelpRequest()
    }
    
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        sortMenus?.delegate = self
        viewModel
            .$products
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.sortProductsIndicator.send(false)
                self.filters.paging.finished(paginator: data?.paginator)
                
                DispatchQueue.main.async {
                    if (data?.paginator?.current_page ?? 1) == 1 {
                        self.products.append(contentsOf: data?.products ?? [])
                        self.reload(section: Section.products.rawValue)
                    } else {
                        
                        let indexPaths = self.collection.forInsert(
                            self.products,
                            data?.products,
                            Section.products.rawValue
                        )
                        
                        self.products.append(contentsOf: data?.products ?? [])
                        
                        self.collection.insertItems(at: indexPaths)
                        
                    }
                }
                
            }.store(in: &bag)
        
        viewModel
            .productsError
            .sink { [weak self] isError in
                guard let self = self, isError else { return }
                self.sortProductsIndicator.send(false)
                self.filters.paging.isLoading = false
                self.filters.paging.current -= 1
            }.store(in: &bag)
        
        sortProductsIndicator.sink { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? self.showCenterProgress() : self.hideCenterProgress()
        }.store(in: &bag)
        
        viewModel
            .$routeCategory
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.category = data?.category
            }.store(in: &bag)
        
        viewModel
            .$category
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.category = data
            }.store(in: &bag)
        
        productHelper
            .pushParentProduct
            .sink { [weak self] data in
                guard let self = self else { return }
                self.coordinator?.presentCartVariation(product: data,
                                                       productType: .product)
            }.store(in: &bag)
        
        viewModel
            .productsIndicator
            .dropFirst()
            .sink { [weak self] isLoading in
                guard let self = self else { return }
//                self.productsSkeleton.isAnimating = isLoading
            }.store(in: &bag)
        
        setupCategoryProductsObserver()
        setupBrandsObserver()
        initialObservers()
        pushObservers()
    }
    
    private func pushObservers() {
        pushAllBrandsObserver
            .sink { [weak self] canOpen in
                guard let self = self else { return }
                if canOpen {
                    self.coordinator?.pushAllBrands()
                }
            }.store(in: &bag)
        
        pushBrandObserver
            .sink { [weak self] brand in
                guard let self = self,
                      let brand = brand else { return }
                self.coordinator?.pushBrandProducts(filters: ProductListFilters().setStaticManufacturer(brand))
            }.store(in: &bag)
        
        pushCategoryObserver
            .sink { [weak self] value in
                guard let self = self,
                      let category = value.0 else { return }
                
                let brand = value.1 ?? self.brand
                
                if (category.children?.isEmpty ?? true) {
                    let filters = ProductListFilters()
                    filters.category = category
                    filters.selectedManufacturer = brand
                    self.coordinator?.pushProductsList(filters: filters)
                } else {
                    self.coordinator?.pushCatalogListPage(pageState: .category(category, brand))
                }
            }.store(in: &bag)
        
        pushSliderObserver
            .sink { [weak self] slider in
                guard let self = self else { return }
                self.coordinator?.pushSlider(slider)
            }.store(in: &bag)
        
        pushAllProductObserver
            .sink { [weak self] model in
                guard let self = self else { return }
                
                self.coordinator?.pushProductsListPage(
                    category: model,
                    brand: self.brand,
                    catalogStack: self.coordinator?.selectedCatalogStack ?? []
                )
                
            }.store(in: &bag)
        
        productHelper
            .pushProduct
            .sink { [weak self] model in
                guard let self = self else { return }
                self.coordinator?.pushProductPage(product: model)
            }.store(in: &bag)
        
        pushSubcatalogObserver
            .sink { [weak self] model in
                guard let self = self else { return }
                if (model?.children?.isEmpty ?? true) {
                    self.pushAllProductObserver.send(model)
                } else {
                    self.coordinator?.pushCatalogListPage(pageState: .category(model, self.brand))
                }
            }.store(in: &bag)
    }

    private func initialObservers() {
        viewModel
            .$sliders
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.helper.sliders = data
                self.collection.changeState(at: Section.banner.rawValue,
                                            state: .loaded)
                self.initialReload()
            }.store(in: &bag)
        
        viewModel
            .slidersError
            .sink { [weak self] isError in
                guard let self = self, isError else { return }
                self.collection.changeState(at: Section.banner.rawValue,
                                            state: .loaded)
                self.initialReload()
            }.store(in: &bag)
        
        viewModel
            .$popular
            .sink { [weak self] data in
                guard let self = self else { return }
                self.helper.popularProducts = data
                self.collection.changeState(at: Section.popular.rawValue,
                                            state: .loaded)
                DispatchQueue.main.async {
//                    self.collection.reloadData()
                    self.collection.collectionViewLayout.invalidateLayout()
                }
                self.initialReload()
            }.store(in: &bag)
        
        viewModel
            .popularError
            .sink { [weak self] isError in
                guard let self = self else { return }
                self.collection.changeState(at: Section.popular.rawValue,
                                            state: .loaded)
                self.initialReload()
            }.store(in: &bag)
    }
    #warning("Needs refactoring")
    private func setupCategoryProductsObserver() {
        viewModel
            .$categoryProducts
            .sink { [weak self] data in
                guard let self = self else { return }

                self.helper.categoriesPaging.isLoading = false
                let category = data?.category
                
                guard let section = self.helper.categories.firstIndex(where: { $0.id == category?.id }) else { return }
                
                self.helper.categories[section].categoryProducts = data
                
                DispatchQueue.main.async {
                    
                    do {
                        
                        self.collection.performBatchUpdates {
                            let newIndexPath = IndexPath(
                                item: self.helper.loadedCategoryProducts.count,
                                section: Section.categoryProducts.rawValue)
                            
                            self.helper.loadedCategoryProducts.append(self.helper.categories[section])
                            self.collection.insertItems(at: [newIndexPath])
                        } completion: { isUpdated in
                            if isUpdated {
                                
                            }
                        }
                    } catch {}

                }
                
            }.store(in: &bag)
        
        viewModel
            .productsPaginationError
            .sink { [weak self] isError in
                guard let self = self else { return }
                self.sortProductsIndicator.send(false)
                self.helper.categoriesPaging.isLoading = false
                self.helper.categoriesPaging.current -= 1
            }.store(in: &bag)
    }
    
    private func setupBrandsObserver() {
        viewModel
            .$brands
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.helper.brandsPaging.isLoading = false
                self.helper.brands = data
                DispatchQueue.main.async {
                    if let brand = self.helper.brands {
                        let newIndexPath = IndexPath(
                            item: 0,
                            section: Section.brands.rawValue
                        )
                        
                        self.collection.insertItems(at: [newIndexPath])
                    }
                }
                
                self.helper.isReadyProducts = true
                self.loadCategoryProductsNewly()
            }.store(in: &bag)
        
        viewModel
            .brandsError
            .sink { [weak self] isError in
                guard let self = self,
                      isError else { return }
                self.helper.brandsPaging.isLoading = false
                
                self.helper.isReadyProducts = true
                self.loadCategoryProductsNewly()
            }.store(in: &bag)
    }
    
    func initialReload() {
        
        if isLoaded(.banner, .popular) {
            loadProducts()
            helper.initialReloaded = true
             changeCellType()
        }
        
    }
    
    func isLoaded(_ loadedSections: Section...) -> Bool {
        var status: [Bool] = []
        for section in loadedSections {
            status.append(collection.isLoaded(at: section.rawValue))
        }
        return status.filter { $0 == false }.isEmpty
    }
    
    deinit {
        bag.forEach { cancellable in
            cancellable.cancel()
        }
    }
}
