//
//  ProductsListPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/07/22.
//

import UIKit
import Combine
import ViewAnimator
import Differ
import SkeletonView
import OlchaUI
open class ProductsListPage: BaseViewController, SkeletonCollectionViewDataSource {
    
    
    enum Section: Int {
        case products = 0
        case placeholder = 1
        case footer = 2
    }
    
    //MARK: - Reactive
    var bag = Set<AnyCancellable>()
    
    //MARK: - UI
    
    let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    var layout: Composition?
    var header: ProductsListHeader?
    
    var sectionHeader: ProductsListHeader?
    
    let filterButton = FilterButton()
    
    //MARK: - Logic
    public let catalogViewModel = CatalogPageViewModel()
    let featuresViewModel = FeaturesPageViewModel()
    let layoutManager = CatalogLayoutManager()
    weak var coordinator: ProductCoordinatorProtocol?
    let pageObserver = PageObserver()
    
    
    //MARK: - Properties

    var products: [ProductModel] = []
    var filters : ProductListFilters = .init()
    var uiFilter = ProductListPageUIFilter()
    var productsSkeleton = Skeleton(count: 9)
    
    var productHelper: ProductHelper? = ProductHelper()
    
    func sections() -> [Section] {
        [
            .products,
            .placeholder,
            .footer
        ]
    }
    
    var animatingCells: [IndexPath: UICollectionViewCell] = [:]
    
    var withPlaceholder = true
    
    override func setupViews() {
        super.setupViews()
        setupSortMenus()
        container.addSubview(collection)
        collection.addSubview(refreshControl)
        container.addSubview(filterButton)
    }
    
    override func autolayout() {
        super.autolayout()
        collection.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        filterButton.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.bottom.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    override func configureViews() {
        super.configureViews()
        tabbarAnimated = true
//        filters.observers = .init()
//        filters.filterPrice = .init()
        
        if filters.selectedSort == .none {
            filters.selectedSort = .popular
        }
        
        navigation.configure(style: .back)
        navigation.setTitle(filters.navigationTitle)
        collection.backgroundColor = .olchaBackgroundColor
        collection.registerClass(forCell: BannerItem.self)
        collection.registerClass(forCell: PaginatorCell.self)
        collection.registerClass(forHeader: ProductsListHeader.self, kind: UICollectionView.elementKindSectionHeader)
        collection.registerClass(forCell: EmptyPlaceholderItem.self)
        collection.registerClass(forCell: ProductCell.self)
        collection.registerClass(forCell: FooterCollectionItem.self)
        collection.dataSource = self
        collection.delegate = self
        collection.contentInset = .init(top: 0, left: 0, bottom: 60, right: 0)
        
        
        changeCellType()
        filterButton.countFeatures(filters: self.filters)
        filterButton.shadowAdd()
        
        categoryUpdated()
        
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        changeTabBar(hidden: false, animated: true)
    }
    
    func categoryUpdated() {
        guard let category = filters.category else { return }
        navigation.setTitle(filters.navigationTitle)
        
        reloadCollection()
        
        
        if let index = filters.catalogStack.firstIndex(where: { $0.id == category.id || $0.alias == category.alias })
        {
            filters.catalogStack[index] = category
        }
        
        if filters.catalogStack.isEmpty {
            filters.catalogStack = [category]
        }
    }
    
    override func setupObservers() {
        self.baseSetupObservers(viewModel: self.catalogViewModel)
        
        filters
            .observers
            .tagSelected
            .sink { [weak self] isUpdated in
                guard let self = self else { return }
                if isUpdated {
                    self.filterUpdated(type: .tag)
                    self.collection.reloadData()
//                    self.loadFilteredFeatures(isManufacturer: false)
                }
            }.store(in: &bag)
        
        filters
            .observers
            .filterSelected
            .sink { [weak self] isUpdated in
                guard let self = self else { return }
                if isUpdated {
                    self.filterUpdated(type: .features)
                    self.collection.reloadData()
                    self.loadFilteredFeatures(isManufacturer: false)
                }
            }.store(in: &bag)
        
        filters
            .observers
            .manufacturerSelected
            .sink { [weak self] isUpdated in
                guard let self = self else { return }
                if isUpdated {
                    self.filterUpdated(type: .features)
                    
                    self.collection.reloadData()
                    self.loadFilteredFeatures(isManufacturer: true)
                }
            }.store(in: &bag)
        
        catalogViewModel
            .$products
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }

                self.filters.paging.finished(paginator: data?.paginator)
                self.products.append(contentsOf: data?.products ?? [])
//                self.collection.reloadData()
                self.collection.collectionViewLayout.invalidateLayout()
            }.store(in: &bag)
        
        featuresViewModel
            .$features
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                
                
                self.filters.setManufacturers(oldValues: self.filters.manufacturers,
                                              newValues: (data?.manufacturers ?? []))
                
                self.filters.features = data?.features ?? []
                
//                if self.filters.selectedManufacturer != nil {
//                    self.filters.observers.manufacturerSelected.send(true)
//                }
                
                self.changeCellType(animation: false)
                
            }.store(in: &bag)
        
        featuresViewModel
            .$tags
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.filters.tags = data?.tags ?? []
                
                self.changeCellType(animation: false)
                
            }.store(in: &bag)
        
        
        catalogViewModel
            .productsError
            .dropFirst()
            .sink { [weak self] isError in
                guard let self = self else { return }
                if isError {
                    self.filters.paging.isLoading = false
                    self.filters.paging.current -= 1
                }
            }.store(in: &bag)
        
        
        filters
            .observers
            .openFeatureFilter
            .sink { [weak self] index in
                guard let self = self else { return }
                self.coordinator?.presentFeaturesFilterModal(with: self.filters, index: index)
            }.store(in: &bag)
        
        filters
            .observers
            .openPriceFilter
            .sink { [weak self] id in
                guard let self = self else { return }
                self.coordinator?.presentPriceFilterModal(with: self.filters)
            }.store(in: &bag)
        
        filters
            .observers
            .openManufacturersFilter
            .sink { [weak self] id in
                guard let self = self else { return }
                self.coordinator?.presentManufacturersFilterModal(with: self.filters)
            }.store(in: &bag)
        
        categoryObserver()
        
        filters
            .observers
            .categoryUpdated
            .sink { [ weak self ] canLoad in
                guard let self = self else { return }
                self.navigation.setTitle(self.filters.navigationTitle)
                
                self.filters.resetAllFilters()
                self.initialRequest()
            }.store(in: &bag)
        

        filters
            .observers
            .loadProductsObserver
            .sink { [weak self] isUpdated in
                if isUpdated {
                    self?.filterUpdated(type: .none)
                }
            }.store(in: &bag)
        
        
        filterButton
            .clicked { [weak self] in
                guard let self = self else { return }
                self.coordinator?.pushFeaturesPage(filters: self.filters)
            }
        
        productHelper?
            .pushProduct
            .sink { [weak self] model in
                guard let self = self else { return }
                self.coordinator?.pushProductPage(product: model)
            }.store(in: &bag)
        
        productHelper?
            .pushParentProduct
            .sink { [weak self] data in
                guard let self = self else { return }
                self.coordinator?.presentCartVariation(product: data, productType: .product)
            }.store(in: &bag)
        
        catalogViewModel
            .$category
            .sink { [weak self] data in
                guard let self = self,
                      let category = data else { return }

                self.filters.category = category
                self.categoryUpdated()
                
            }.store(in: &bag)
        
        catalogViewModel
            .productSkeletonIndicator
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                self.productsSkeleton.isAnimating = isLoading
                self.filters.paging.isLoading = isLoading
                self.collection.reloadData()
            }.store(in: &bag)
        
        catalogViewModel
            .productsIndicator
            .sink { [weak self] isLoading in
                guard let self else { return }
                self.filters.paging.isLoading = isLoading
                self.collection.reloadSections(.init(integer: Section.footer.rawValue))
            }.store(in: &bag)
        
        sortMenus?.delegate = self
        
    }
    
    open func categoryObserver() {
        filters
            .observers
            .openCategoryFilter
            .sink { [weak self] canOpen in
                guard let self = self else { return }
                if canOpen {
                    self.coordinator?.presentCategoryListFilterModal(filters: self.filters)
                }
            }.store(in: &bag)
    }
    
    override func initialRequest() {
        super.initialRequest()
        self.products.removeAll()
        self.reloadCollection()
        
        let alias = Funcs.getCategoryAlias(category: filters.category)
        
        if alias != "" {
            catalogViewModel.loadCategory(with: alias)
            featuresViewModel.loadFeatures(with: alias)
            featuresViewModel.loadTags(with: alias)
        }
        
        loadMore()
    }
    
    override func refreshList(_ sender: AnyObject) {
        if !collection.isDragging {
            products.removeAll()
            filters.paging = .init()
            initialRequest()
        }
    }
    
    
    func changeCellType(animation: Bool = true) {
        
        if let layout = getLayout() {
            collection.collectionViewLayout = layout
        }
        
        guard animation else { collection.reloadData(); return }
        
        guard !uiFilter.isAnimating else {
            collection.reloadData()
            return
        }
        
        uiFilter.isAnimating = true
        
        collection.animateProductShrink(filters.cellType,
                                        section: Section.products.rawValue) { [ weak self ] in
            guard let self = self else { return }
            
            self.uiFilter.isAnimating = false
        }
    }
    
    open func getLayout() -> UICollectionViewLayout? {
        return layoutManager.getLayout(
            with: .productsList(type: filters.cellType,
                                tagsEmpty: filters.tags.isEmpty)
        )
    }
    
    func loadFilteredFeatures(isManufacturer: Bool) {
        let alias = Funcs.getCategoryAlias(category: filters.category)
        if alias != "" {
            featuresViewModel.loadFilteredFeatures(categoryAlias: alias,
                                                   filters: filters,
                                                   isManufacturer: isManufacturer)
        }
    }
    
    func filterUpdated(type: ProductListFilters.FilterType) {
        filters.featureSelected(type: type)
        filterButton.countFeatures(filters: filters)
        loadNewly()
        reloadCollection()
    }
    
    func reloadCollection() {
        collection.reloadData()
    }
    
    open func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ProductCell.classIdentifier
    }
}


