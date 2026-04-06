//
//  HomePage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 23/08/22.
//

import UIKit
import OlchaUI
import Combine
import SnapKit
import OlchaCore
import OlchaAuth
import OlchaUtils

class HomePage: BaseViewController {
    //MARK: - UI
    var staticSections: [ HomeSection ] = [ .mainBanner, .categories, .dailyProducts, .gridBanners ]
    var sections: [ HomeSection ] {
        var sections: [ HomeSection ] = []
        sections.append(contentsOf: staticSections)
//        sections.append(contentsOf: contentSections)
        sections.append(.products)
        
        return sections
    }
    
    var contentSections: [ HomeSection ] = []
    
    let table = BaseTableView()
    var dotPictureRoom: DotPictureRoom?
    
    //MARK: - Navigation bottom bar
    let bottomBar = UIView()
    let searchView = SearchView()
    let searchButton = Button()
    let extraView = UIStackView()
    let saleButton = Button()
    let monthlyButton = Button()
    let navigationBottomBarHeight: CGFloat = 44
    var expandHeigthConstraint: Constraint?
    var shrinkHeigthConstraint: Constraint?
    
    //MARK: - Coordinator
    weak var coordinator: HomeCoordinatorProtocol?
    
    //MARK: - Properties
    var hasDisappeared: Bool = false
    var mainBanners: [Slider] = []
    let mainBannersSkeleton = Skeleton(count: 4)
    
    var categories: [CategoryModel] = []
    let categorySkeleton = Skeleton(count: 6)
    
    var discountBanners : [Discount] = []
    
    var dailyProducts: ProductsData? {
        didSet {
            
        }
    }
    let dailyProductsSkeleton = Skeleton(count: 4)
    
    var componentModels: [HomeComponentModel] = []
    
    //MARK: - ViewModels
    let catalogPageViewModel = CatalogPageViewModel()
    let homePageViewModel = HomePageViewModel()
    
    
    //MARK: - Observers
    var bag = Set<AnyCancellable>()
    
    
    let pushHeaderObserver = PassthroughSubject<ComponentDataModel?, Never>()
    
    let pushCategoryObserver = PassthroughSubject<(CategoryModel?, Manufacturer?), Never>()
    let pushMainCategoryObserver = PassthroughSubject<(CategoryModel?, Manufacturer?), Never>()
    
    let pushBrandObserver = PassthroughSubject<Manufacturer?, Never>()
    let pushSliderObserver = PassthroughSubject<Slider?, Never>()
    let pushDiscountObserver = PassthroughSubject<Discount?, Never>()
    let pushBlogObserver = PassthroughSubject<Blog?, Never>()
    let pushAllBrandsObserver = PassthroughSubject<Bool, Never>()
    
    let productHelper = ProductHelper()
    
    let productsObserver = HomePageProductsObserver()
    
    var topExtraNavigationHidden = false
    
    let segmentHeaderHeight: CGFloat = 44
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(table)
        table.addSubview(refreshControl)
        baseSetupNavigationBottomView()
    }
    
    override func autolayout() {
        super.autolayout()
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.configure(style: .main)
        table.delegate = self
        table.dataSource = self
        table.contentInsetAdjustmentBehavior = .never
        
        table.configure()
        table.registerClass(forCell: MainBannerRoom.self)
        table.registerClass(forCell: CategoriesRoom.self)
        table.registerClass(forCell: DiscountBannersRoom.self)
        table.registerClass(forCell: HorizontalPromotedRoom.self)
        table.registerClass(forCell: VerticalPromotedRoom.self)
        table.registerClass(forCell: NewCategoriesRoom.self)
        table.registerClass(forCell: SingleBrandsRoom.self)
        table.registerClass(forCell: DoubledBrandsRoom.self)
        table.registerClass(forCell: NewsRoom.self)
        table.registerClass(forCell: DotPictureRoom.self)
        table.registerClass(forCell: ComponentHeader.self)
        table.registerClass(forCell: GroupedProductsRoom.self)
        table.registerClass(forCell: HomeProductPageControlRoom.self)
        table.registerClass(forHeaderFooter: HomeProductPageControlRoomHeader.self)
        
        table.contentInset = .init(top: navigationBottomBarHeight , left: 0, bottom: 0, right: 0)
        
        table.contentOffset = .init(x: 0, y: -(navigationBottomBarHeight))
        table.showsVerticalScrollIndicator = false
        
        
        
//        table.sectionHeaderHeight = 0
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        
        productsObserver.productHelper = productHelper
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
////        let isTest = (Texts.url.olcha.base == Texts.url.olcha.test)
//        #if DEBUG
//        navigation.home.backgroundColor = .blue
//        #else
//        navigation.home.backgroundColor = .olchaWhite
//        #endif
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        changeTabBar(hidden: false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hasDisappeared = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hasDisappeared = true
        changeTabBar(hidden: false, animated: false)
    }
    
    override func languageUpdated() {
        
        navigationController?.popToRootViewController(animated: true)
        searchView.setPlaceholder()
        table.setContentOffset(.zero, animated: true)
        table.reloadData()
        productsObserver.collectionReloader.send(true)
        saleButton.setTitle("sale".localized(), for: .normal)
        monthlyButton.setTitle("monthly".localized(), for: .normal)
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: homePageViewModel)
        homePageViewModel
            .$builders
            .dropFirst()
            .sink { [weak self] builders in
                guard let self = self else { return }
                var buildersList: [HomeSection] = []
                for builder in builders {
                    if let componentType = builder.component_type {
                        buildersList.append(.builder(componentType: componentType))
                    }
                    self.componentModels.append(HomeComponentModel(model: builder))
                }
                
                contentSections = buildersList
                
                self.loadInitialComponentDatas()
                self.table.reloadData()
            }.store(in: &bag)
        
        homePageViewModel
            .$mainBanners
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.mainBanners = data?.sliders ?? []
//                self.table.reloadData()
                self.reload(section: HomeSection.mainBanner.index)
            }.store(in: &bag)
        
        homePageViewModel
            .$discounts
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                
                self.discountBanners = data?.discounts ?? []
                self.table.reloadData()
//                self.reload(section: HomeSection.gridBanners.index)
            }.store(in: &bag)
        
        catalogPageViewModel
            .$categories
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.categories = data?.parent_categories ?? []
//                self.table.reloadData()
                self.reload(section: HomeSection.categories.index)
            }.store(in: &bag)
        
        catalogPageViewModel
            .$dailyProducts
            .sink { [weak self] data in
                guard let self = self else { return }
                self.dailyProducts = data
//                self.table.reloadData()
                self.reload(section: HomeSection.dailyProducts.index)
            }.store(in: &bag)
     
        catalogPageViewModel
            .$routeProducts
            .sink { [weak self] routeProducts in
                guard let self = self,
                      let index = routeProducts?.0,
                      self.componentModels.isEmpty == false
                else {
                    return
                }

                if index < self.componentModels.count {
                    self.componentModels[index].productsData = routeProducts?.1
                    self.reload(section: self.staticSections.count + index)
                }
                
            }.store(in: &bag)
        
        catalogPageViewModel
            .$routeCategories
            .sink { [weak self] routeCategories in
                guard let self = self,
                      let index = routeCategories?.0,
                      self.componentModels.isEmpty == false
                else {
                    return
                }
                
                if index < self.componentModels.count {
                    self.componentModels[index].categoriesData = routeCategories?.1
                    self.reload(section: self.staticSections.count + index)
                }
            }.store(in: &bag)
        
        
        catalogPageViewModel
            .$routeBrands
            .sink { [weak self] routeBrands in
                guard let self = self,
                      let index = routeBrands?.0,
                      self.componentModels.isEmpty == false
                else {
                    return
                }
                
                if index < self.componentModels.count {
                    self.componentModels[index].brands = routeBrands?.1
                    self.reload(section: self.staticSections.count + index)
                }
            }.store(in: &bag)
        
        homePageViewModel
            .$blogs
            .sink { [weak self] routeBlogs in
                guard let self = self,
                      let index = routeBlogs?.0,
                      self.componentModels.isEmpty == false
                else {
                    return
                }
                
                if index < self.componentModels.count {
                    self.componentModels[index].news = routeBlogs?.1
                    self.reload(section: self.staticSections.count + index)
                    
                }
            }.store(in: &bag)
        
        catalogPageViewModel
            .$builderErrorIndex
            .dropFirst()
            .sink { [weak self] index in
                guard let self = self,
                let index = index else { return }
                
                self.table.changeState(at: index, state: .notLoaded)
                
            }.store(in: &bag)
        
        homePageViewModel
            .$builderErrorIndex
            .dropFirst()
            .sink { [weak self] index in
                guard let self = self,
                let index = index else { return }
                
                self.table.changeState(at: index, state: .notLoaded)
                
            }.store(in: &bag)
        
        homePageViewModel
            .$filters
            .sink { [weak self] data in
                guard let self else { return }
                setupHomeFilters(data?.filters)
            }.store(in: &bag)
        
        navigation.home.callButton.clicked {
            Funcs.openPhone()
        }
        
        pushObservers()
        indicatorObservers()
    }
    
    private func setupHomeFilters(_ filters: [HomeSegmentModel]?) {
        productsObserver.homeProductPages = filters ?? []
        productsObserver.setupViewControllersObserver.send(filters ?? [])
    }
    
    private func pushObservers() {
        productHelper
            .pushParentProduct
            .sink { [weak self] data in
                guard let self = self else { return }
                coordinator?.presentCartVariation(product: data, productType: .product)
            }.store(in: &bag)
        
        
        productHelper
            .pushProduct
            .sink { [weak self] product in
                guard let self = self else { return }
                coordinator?.pushProductPage(with: product)
            }.store(in: &bag)
        
        pushHeaderObserver
            .sink { [weak self] model in
                
                guard let self = self,
                      let model = model
                else {
                    return
                }
                self.componentPush(model: model)
            }.store(in: &bag)
        
        
        pushCategoryObserver
            .sink { [weak self] value in
                guard let self = self,
                      let category = value.0 else { return }
                let brand = value.1
                
                if (category.children?.isEmpty ?? true) {
                    let filters = ProductListFilters()
                    filters.category = category
                    filters.selectedManufacturer = brand
                    self.coordinator?.pushProductsList(with: filters)
                } else {
                    self.coordinator?.pushCatalogListPage(pageState: .category(category, brand))
                }
            }.store(in: &bag)
        
        pushMainCategoryObserver
            .sink { [weak self] value in
                guard let self = self,
                let category = value.0 else { return }
                self.coordinator?.pushCatalogListPage(pageState: .category(category, nil))
            }.store(in: &bag)
        
        pushSliderObserver
            .sink { [weak self] slider in
                guard let self = self else { return }
                self.coordinator?.pushSlider(slider)
            }.store(in: &bag)
        
        pushDiscountObserver
            .sink { [weak self] discount in
                guard let self = self else { return }
                self.discountPush(discount)
            }.store(in: &bag)
        
        saleButton.clicked { [weak self] in
            guard let self = self else { return }
            let filters = ProductListFilters()
            filters.productsType = .has_discount
            filters.selectedSort = .discountHigh
            self.coordinator?.pushProductsList(with: filters)
        }
        
        monthlyButton.clicked { [weak self] in
            guard let self = self else { return }
            let filters = ProductListFilters()
            filters.productsType = .has_installment
            self.coordinator?.pushProductsList(with: filters)
        }
        
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
        
        pushBlogObserver
            .sink { [weak self] blog in
                guard let self = self else { return }
                self.coordinator?.pushBlog(blog: blog)
            }.store(in: &bag)
        
        navigation.home.notificationButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pushNotificationPage()
        }
    }
    
    private func indicatorObservers() {
        homePageViewModel
            .mainBannersIndicator
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                self.mainBannersSkeleton.isAnimating = isLoading
                self.reload(section: HomeSection.mainBanner.index)
            }.store(in: &bag)
        
        catalogPageViewModel
            .categoriesIndicator
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                self.categorySkeleton.isAnimating = isLoading
                self.reload(section: HomeSection.categories.index)
            }.store(in: &bag)
        
        catalogPageViewModel
            .dailyProductIndicator
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                self.dailyProductsSkeleton.isAnimating = isLoading
                self.reload(section: HomeSection.dailyProducts.index)
            }.store(in: &bag)
            
        productsObserver.scrollObserver.sink { [weak self] scrollType in
            guard let self else { return }
            table.isScrollEnabled = (scrollType == .table)
        }.store(in: &bag)
        
        productsObserver.scrollObserver.sink { type in
            
        }.store(in: &bag)
    }
    
    override func initialRequest() {
        super.initialRequest()
        homePageViewModel.loadHomeBuilder()
        homePageViewModel.loadBanners()
        homePageViewModel.loadDiscounts()
        homePageViewModel.loadProductFilters()
        catalogPageViewModel.loadCategories()
        catalogPageViewModel.loadDailyProducts()
    }
    
    override func refreshList(_ sender: AnyObject) {
        clearRefreshList()
        table.resetStates()
        
        homePageViewModel.loadHomeBuilder()
        homePageViewModel.loadBanners()
        homePageViewModel.loadDiscounts()
        catalogPageViewModel.loadCategories()
        catalogPageViewModel.loadDailyProducts()
        homePageViewModel.loadProductFilters()
        refreshControl.endRefreshing()
    }
    
    private func clearRefreshList() {
        setupHomeFilters([])
    }
    
    func loadComponentDatas(index: Int) {
        
        guard index < componentModels.count,
              table.isLoaded(at: index) == false,
              let content = componentModels[index].component?.content
        else {
            return
        }
        
        table.changeState(at: index, state: .loaded)
        
        let component = HomeRoomType(rawValue: componentModels[index].component?.component_type ?? "")
        
        switch component {
        case .verticalProducts, .horizontalProducts:
            let filter = ProductListFilters()
            filter.route = content.route ?? ""
            catalogPageViewModel.loadRouteProducts(index: index, filter: filter)
            break
        case .groupedProducts:
            let filter = ProductListFilters()
            filter.route = content.route ?? ""
            filter.paging.per_page = 6
            catalogPageViewModel.loadRouteProducts(index: index, filter: filter)
            break
        case .brands:
            catalogPageViewModel.loadBrands(index: index, route: content.route ?? "")
            break
        case .dotsPicture:
            break
        case .news:
            homePageViewModel.loadBlogs(index: index, route: content.route ?? "")
            break
        case .horizontalGridCategories:
            catalogPageViewModel.loadCategories(index: index, route: content.route ?? "")
            break
        default: break
        }
        
    }
    
    func loadInitialComponentDatas() {
        
        loadComponentDatas(index: 0)
        loadComponentDatas(index: 1)

        
    }
    
    private func reload(section: Int) {
        guard !hasDisappeared else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            //
            //        }
//            UIView.animate(withDuration: 0.3) { [weak self] in
//                guard let self else { return }
                if section < sections.count {
                    //                table.reloadData()
//                    table.beginUpdates()
//                    table.layoutIfNeeded()
                    do {
                        self.table.reloadSections(.init(integer: section), with: .fade)
                    } catch {}
//                    table.reloadData()
//                    table.endUpdates()
                    
//                }
            }
        }
    }
    
}

extension HomePage {
    
    func componentPush(model: ComponentDataModel) {
        guard
            let route = model.route,
            let openType = model.open_type
        else {
            return
        }

        let type = HomeOpenType(rawValue: openType)
        switch type {
        case .product:
            let product = Funcs.getProductModel(id: model.product_id)
            self.productHelper.pushProduct.send(product)
            break
        case .productList:
            let filters = ProductListFilters()
            filters.route = route
            if let id = model.category_id, id != 0 {
                filters.category = Funcs.getCategoryModel(id: id)
            }
            
            if let id = model.manufacturer_id, id != 0 {
                filters.selectedManufacturer = Funcs.getManufacturer(id: id)
            }
            
            coordinator?.pushProductsList(with: filters)
            break
        case .categorList:
            coordinator?.pushDifferentCategoriesList(route: route)
            break
        case .category:
            coordinator?.pushCatalogListPage(pageState: .route(route))
            break
        case .store:
            let filters = ProductListFilters()
            filters.stores = [Store(id: model.store_id,
                                    name: model.name,
                                    name_ru: model.name_ru,
                                    name_uz: model.name_uz,
                                    name_oz: model.name_ru)]
            
            
            
            coordinator?.pushProductsList(with: filters)
            break
        case .brandsList:
            break
        default:
            break
        }
                
    }
    
    func discountPush(_ discount: Discount?) {
        guard let discount = discount else {
            return
        }
        
        let filters = ProductListFilters()
        filters.discountID = discount.id
        
        let alias = Funcs.splitCategory(link: discount.link)
        if alias != "" {
            filters.category = Funcs.getCategoryModel(alias: alias)
        }
        
        coordinator?.pushProductsList(with: filters)
    }
}
