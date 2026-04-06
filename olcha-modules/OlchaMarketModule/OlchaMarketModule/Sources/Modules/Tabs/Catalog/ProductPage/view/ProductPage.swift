//
//  ProductPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/07/22.
//
import OlchaUI
import UIKit
import Combine
class ProductPage: BaseViewController {
    
    
    var tableSize: [IndexPath: CGFloat] = [IndexPath: CGFloat]()
    var tableReload: [IndexPath: Bool] = [IndexPath: Bool]()
    
    let sections: [ProductPage.Sections] = [
        .images,
        .video,
        .reviewButtons,
        .productsData,
        .cashAd,
        .variations,///needs to fix
        .gift,
        .buyActions,
        .shippingData,
        .storeProducts,
        .description,
        .warranty,
        .faqs,
        .priceHistory,
        .brand,
        .reviews,
        .analogProducts,
        .similarProducts
    ]
    
    var loadedSection: [ProductPage.Sections: Bool] = [:]
    
    private var bag = Set<AnyCancellable>()
    let table = BaseTableView()
    
    //MARK: - Bottom actions
    private let bottomActionsContainer = UIView()
    private let bottomTitlesStack = UIStackView()
    private let bottomActionsOldPrice = UILabel()
    private let bottomActionsPrice = UILabel()
    private let buttonStack = UIStackView()
    private let creditButton = OlchaButton()
    private let cartButton = IconButton()
    
    
    //MARK: - ViewModels
    private let viewModel = ProductViewModel()
    
    
    private let brandViewModel = BrandPageViewModel()
    let reviewsViewModel = ReviewsPageViewModel()
    let catalogViewModel = CatalogPageViewModel()
    let compareViewModel = CompareViewModel.shared
    
    let filters = ProductListFilters()
    let helper = VariationHelper()
    //MARK: - Models
    var fullProduct: FullProductData?
    var product: ProductModel? {
        didSet {
            checkIsFavourite()
            checkIsCompared()
            fillDatas()
        }
    }
    var is_compared: Bool = false {
        didSet {
            compareButton(isAdded: is_compared)
            product?.is_compared = is_compared
        }
    }
    var isLiked: Bool = false {
        didSet {
            favouriteButton(isLiked: isLiked)
            product?.is_like = isLiked
        }
    }
    var isLoading: Bool = false
    var isScrolling: Bool = false
    
    var similarProducts : ProductsData?
    var analogProducts : ProductsData?
    var seenAlsoProducts : ProductsData?
    var brandCategories: CatData?
    var reviews: ReviewsData?
    var reviewFiles: ReviewFilesData?
    var characteristicsData: CharacteristicsData?
    var pricesHistoryData: PriceHistoryData?
    var faqs: ReviewsData?
    
    weak var coordinator: ProductCoordinatorProtocol?
    //MARK: - Observers
    let pushAllBrandsObserver = PassthroughSubject<Bool, Never>()
    let pushBrandObserver = PassthroughSubject<Manufacturer?, Never>()
    let pushCategoryObserver = PassthroughSubject<(CategoryModel?, Manufacturer?), Never>()
    let pushStoreObserver = PassthroughSubject<Store?, Never>()
    let mainTableReloader = PassthroughSubject<ProductPage.Sections, Never>()
    let reviewButtonClicker = PassthroughSubject<ButtonsType, Never>()
    let segmentObserver = PassthroughSubject<ProductPage.SegmentItem, Never>()
    let scrollToDescription = PassthroughSubject<Bool, Never>()
    let openStoreProducts = PassthroughSubject<Bool, Never>()
    let pushAllFAQs = PassthroughSubject<Bool, Never>()
    let pushFaqReplies = PassthroughSubject<Comment?, Never>()
    let pushReviewReplies = PassthroughSubject<Comment?, Never>()
    let pushAllReviews = PassthroughSubject<Bool, Never>()
    let pushProductMedia = PassthroughSubject<Int, Never>()
    
    let parentObserver = PassthroughSubject<ProductModel?, Never>()
    
    let creditBuyObserber = PassthroughSubject<CartCreditData, Never>()
    
    let pushAllMedia = PassthroughSubject<Int, Never>()
    let pushReviewMedia = PassthroughSubject<(Comment, Int), Never>()
    let likeObserver = PassthroughSubject<(Comment?, LikeSegment.Value), Never>()
    let allReviewMedia = PassthroughSubject<Int, Never>()
    
    let productHelper = ProductHelper()
    
    var descriptionRoom: ProductPage.SegmentItem = .description
    
    var faqsLoaded = false
    var reviewsLoaded = false
    
    lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.container.spacing = 8
        scrollView.settings.contentInset = .init(top: 0, left: 0, bottom: 60, right: 0)
        scrollView.settings.delegate = self
        return scrollView
    }()
    
    let factory = ProductPageFactory()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.disableShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.enableShadow()
    }
    
    override func setupViews() {
//        container.addSubview(table)
        container.addSubview(scrollView)
        container.addSubview(bottomActionsContainer)
        bottomActionsContainer.addSubview(bottomTitlesStack)
        
        bottomTitlesStack.addArrangedSubview(bottomActionsOldPrice)
        bottomTitlesStack.addArrangedSubview(bottomActionsPrice)
        
        bottomActionsContainer.addSubview(buttonStack)
        buttonStack.addArrangedSubview(creditButton)
        buttonStack.addArrangedSubview(cartButton)
        
    }
    
    override func autolayout() {
//        table.snp.makeConstraints { make in
//            make.left.right.bottom.top.equalToSuperview()
//        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomActionsContainer.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        
        bottomTitlesStack.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        buttonStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        
        cartButton.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.top.bottom.equalToSuperview()
        }
        
        creditButton.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.bottom.equalToSuperview()
        }
        
    }
    
    override func configureViews() {
        navigation.configure(style: .product)
        navigation.product.ratingButton.isHidden = true
        
        bottomActionsContainer.backgroundColor = .olchaWhite
        bottomActionsOldPrice.style(.medium, 12)
        bottomActionsOldPrice.textColor = .olchaLightTextColornnnnnn
        
        bottomTitlesStack.axis = .vertical
        bottomTitlesStack.spacing = 0
        
        bottomActionsPrice.style(.bold, 16)
        bottomActionsPrice.textColor = .olchaTextBlack
        
        creditButton.setTitle("buy_credit".localized())
        
        cartButton.setIcon(.cart, edgeSize: 8, isIgnoringEdge: false)
        cartButton.backgroundColor = .olchaGreen
        cartButton.round()
        cartButton.border(with: .olchaGreen, width: 2)
        
        
        bottomActionsContainer.shadowAdd(offset: .init(width: 0,
                                                       height: -4),
                                         color: .black.withAlphaComponent(0.2),
                                         radius: 10)
        
        buttonStack.axis = .horizontal
        buttonStack.spacing = 8
        
        cartButtonState()
        setupScrollView()
    }
    
    private func setupTable() {
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: ComponentHeader.self)
        table.registerClass(forCell: ProductPicturesRoom.self)
        table.registerClass(forCell: ShowVideoRoom.self)
        table.registerClass(forCell: ReviewButtonsRoom.self)
        table.registerClass(forCell: ProductsDataRoom.self)
        table.registerClass(forCell: CashAdRoom.self)
        table.registerClass(forCell: VariationsRoom.self)
        table.registerClass(forCell: ProductsGiftRoom.self)
        
        table.registerClass(forCell: ProductFAQsRoom.self)
        table.registerClass(forCell: ProductFAQsHeaderRoom.self)
        
        
        table.registerClass(forCell: ProductActionsRoom.self)
        table.registerClass(forCell: CharacteristicsRoom.self)
        table.registerClass(forCell: DescriptionsRoom.self)
        table.registerClass(forCell: DescriptionSegmentsRoom.self)
        
        table.registerClass(forCell: StoreProductItem.self)
        table.registerClass(forCell: StoreProductFooteritem.self)
        table.registerClass(forCell: WarrantyRoom.self)
        table.registerClass(forCell: PriceHistoryRoom.self)
        table.registerClass(forCell: ProductBrandRoom.self)
        table.registerClass(forCell: ShippingDataRoom.self)
        table.registerClass(forCell: HorizontalPromotedRoom.self)
        table.registerClass(forCell: ProductReviewsHeaderRoom.self)
        table.registerClass(forCell: ProductReviewsRoom.self)
        
        
        table.estimatedRowHeight = 44.0
        table.contentInset = .init(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    func setupCombineObservers() {
        let productPublishers = Publishers.CombineLatest4(viewModel.$variationsData, viewModel.$fullProduct, viewModel.$characteristicsData, viewModel.$priceHistory)
        
        let catalogPublishers = Publishers.CombineLatest3(catalogViewModel.$similar, catalogViewModel.$analog, brandViewModel.$categories)
        
        let reviewPublishers = Publishers.CombineLatest3(reviewsViewModel.$reviews, reviewsViewModel.$faqs, reviewsViewModel.$reviewFiles)
        
        productPublishers.combineLatest(catalogPublishers, reviewPublishers)
            .sink(receiveValue: { [weak self] (product, catalog, review) in
                guard let self else { return }
                let (variationsData, fullProduct, characteristicsData, priceHistory) = product
                let (similar, analog, categories) = catalog
                let (reviews, faqs, reviewFiles) = review
                
                let isProductLoading = variationsData == .loading || fullProduct == .loading || characteristicsData == .loading || priceHistory == .loading
                let isCatalogLoading = similar == .loading || analog == .loading || categories == .loading
                let isReviewLoading = reviews == .loading || faqs == .loading || reviewFiles == .loading
                
                let isLoading = isProductLoading || isCatalogLoading || isReviewLoading
                self.isLoading = isLoading
            }).store(in: &bag)
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: self.viewModel)
        handle(viewModel.$variationsData, withError: false, success: { [weak self] data in
            guard let self, let data else { return }
            helper.variationResultData(data: data)
            reloadSection(section: .variations)
        })
        
        handle(viewModel.$fullProduct, success: { [weak self] data in
            guard let self, let data else { return }
            fullProduct = data
            product = data.product
            product?.store_id = self.product?.store?.id
            tableReloader()
            loadBrands()
            loadCharacteristics()
            loadReviews()
            loadFAQs()
            loadReviewFiles()
            loadPriceHistory()
            loadVariations()
            cartButtonState()
            loadOtherProducts()
            MetricEvents.shared.openPageEvent(product, ProductPage.self)
        })
        
        handle(viewModel.$characteristicsData, withError: false, success: { [weak self] data in
            guard let self else { return }
            characteristicsData = data
            if (self.product?.getDescription() ?? "") == "" {
                self.descriptionRoom = .characteristics
            }
            self.reloadSection(section: .description)
        })
        
        handle(viewModel.$priceHistory, success: { [weak self] data in
            guard let self else { return }
            pricesHistoryData = data
            navigation.product.ratingButton.isHidden = (data?.priceHistory?.isEmpty ?? true)
            reloadSection(section: .priceHistory)
        })
        
        handle(catalogViewModel.$similar, success: { [weak self] data in
            guard let self else { return }
            similarProducts = data
            reloadSection(section: .similarProducts)
        })
        
        handle(catalogViewModel.$analog, success: { [weak self] data in
            guard let self else { return }
            analogProducts = data
            reloadSection(section: .analogProducts)
        })
        
        handle(brandViewModel.$categories, success: { [weak self] data in
            guard let self else { return }
            brandCategories = data
            reloadSection(section: .brand)
        })
        
        handle(reviewsViewModel.$reviews, success: { [weak self] data in
            guard let self else { return }
            reviews = data
            reloadSection(section: .reviews)
            reloadSection(section: .reviewButtons)
        })
        
        handle(reviewsViewModel.$faqs, success: { [weak self] data in
            guard let self else { return }
            faqs = data
            reloadSection(section: .faqs)
            reloadSection(section: .reviewButtons)
        })
        
        handle(reviewsViewModel.$reviewFiles, success: { [weak self] data in
            guard let self else { return }
            reviewFiles = data
            reloadSection(section: .reviews)
        })
        
        mainTableReloader.sink { [weak self] section in
            guard let self = self else { return }
            self.tableReloader(section)
        }.store(in: &bag)
        
        helper.productLoader.sink { [weak self] alias in
            guard let self = self else { return }
            self.loadProduct(with: alias)
        }.store(in: &bag)
        
        helper.productLoaderError.sink { [weak self] error in
            guard let self = self else { return }
            self.viewModel.errorMessage = error
        }.store(in: &bag)
        
        segmentObserver.sink { [weak self] item in
            guard let self = self else { return }
            self.descriptionRoom = item
            self.reloadSection(section: .description)
        }.store(in: &bag)
        
        scrollToDescription.sink { [weak self] isScroll in
            guard let self = self else { return }
            self.table.scrollToRow(at: IndexPath(row: 0, section: Sections.description.rawValue),
                                   at: .top,
                                   animated: true)
        }.store(in: &bag)
        
        reviewButtonClicker.sink { [weak self] type in
            guard let self = self, !isLoading, !isScrolling else { return }
            isScrolling = true
            switch type {
            case .rating:
                scrollView.settings.scrollToView(view: factory.reviewsHeaderRoom, animated: true)
            case .question:
                scrollView.settings.scrollToView(view: factory.faqsHeaderRoom, animated: true)
            }
        }.store(in: &bag)
        
        
        likeObserver.sink { [weak self] val in
            guard let self = self else { return }
            coordinator?.pushAuth {
                if let id = val.0?.id {
                    if val.1 == .liked {
                        self.reviewsViewModel.likeComment(with: id)
                    }
                    
                    if val.1 == .disliked {
                        self.reviewsViewModel.dislikeComment(with: id)
                    }
                }
            }
        }.store(in: &bag)
        
        compareViewModel
            .$compareProduct
            .sink { [weak self] value in
                guard let self,
                      let isAdded = value?.isAdded,
                      value?.product?.id == self.product?.id
                else { return }
                is_compared = isAdded
            }.store(in: &bag)
        
        CartViewModel
            .shared
            .cartItemChanged
            .sink { [weak self] cartItem in
                guard let self = self else { return }
                if cartItem?.product_id == self.product?.id && cartItem?.store_id == self.product?.getStoreID() {
                    self.product?.cart_count = cartItem?.quantity ?? 0
                    self.cartButtonState()
                }
            }.store(in: &bag)
        
        CartViewModel
            .shared
            .$favouriteChangedID
            .sink { [weak self] id in
                guard let self = self else { return }
                if id == self.product?.id {
                    self.isLiked = !self.isLiked
                    self.product?.is_like = self.isLiked
                }
            }.store(in: &bag)
        
        parentObserver.sink { [weak self] product in
            guard let self = self else { return }
            checkVariation(product: product, productType: .storeProduct)
        }.store(in: &bag)
        
        pushObservers()
        table.canCancelContentTouches = false
    }
    
    private func pushObservers() {
        navigation.product.shareButton.clicked { [weak self] in
            guard let self = self else { return }
            self.presentShareScreen(text: Funcs.getProductLink(product: self.product))
        }
        
        navigation.product.ratingButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.presentPriceHistory(history: self.pricesHistoryData?.priceHistory ?? [])
        }
        
        pushStoreObserver
            .sink { [weak self] data in
                guard let self = self, let data = data else { return }
                let filters = ProductListFilters()
                filters.stores = [data]
                self.coordinator?.pushProductsList(filters: filters)
            }.store(in: &bag)
        
        productHelper
            .pushParentProduct
            .sink { [weak self] data in
                guard let self = self else { return }
                self.coordinator?.presentCartVariation(product: data, productType: .storeProduct)
            }.store(in: &bag)
        
        pushProductMedia.sink { [weak self] index in
            guard let self = self else { return }
            self.coordinator?.pushMedia(images: self.product?.images ?? [],
                                        index: index)
        }.store(in: &bag)
        
        creditButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            presentCreditVariation()
        }
        
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
                let brand = value.1
                
                if (category.children?.isEmpty ?? true) {
                    let filters = ProductListFilters()
                    filters.category = category
                    filters.selectedManufacturer = brand
                    self.coordinator?.pushProductsList(filters: filters)
                } else {
                    self.coordinator?.pushCatalogListPage(pageState: .category(category, brand))
                }
            }.store(in: &bag)
        
        openStoreProducts.sink { [weak self] canOpen in
            guard let self = self else { return }
            self.coordinator?.pushStoreProducts(product: self.product)
        }.store(in: &bag)
        
        productHelper.pushProduct.sink { [weak self] model in
            guard let self = self else { return }
            self.coordinator?.pushProductPage(product: model)
        }.store(in: &bag)
        
        pushReviewMedia.sink { [weak self] (val) in
            guard let self = self else { return }
            self.coordinator?.pushReviewMedia(review: val.0, index: val.1)
        }.store(in: &bag)
        
        pushAllMedia.sink { [weak self] index in
            guard let self = self else { return }
            self.coordinator?.pushReviewMedia(product: self.product,
                                              reviewsData: self.reviewFiles,
                                              index: index)
            
        }.store(in: &bag)
        
        pushAllFAQs.sink { [weak self] canOpen in
            guard let self = self else { return }
            if canOpen { self.coordinator?.pushAllFAQs(product: self.product) }
        }.store(in: &bag)
        
        pushReviewReplies.sink { [weak self] review in
            guard let self = self else { return }
            self.coordinator?.pushReviewReplies(review: review, product: self.product)
        }.store(in: &bag)
        
        pushFaqReplies.sink { [weak self] faq in
            guard let self = self else { return }
            self.coordinator?.pushFAQReplies(question: faq, product: self.product)
        }.store(in: &bag)
        
        pushAllReviews.sink { [weak self] canOpen in
            guard let self = self else { return }
            if canOpen { self.coordinator?.pushAllReviews(product: self.product) }
        }.store(in: &bag)
        
        
        navigation.product.compareButton.clicked { [weak self] in
            guard let self = self else { return }

            if self.is_compared {
                self.compareViewModel.removeCompare(product: self.product)
            } else {
                self.compareViewModel.addToCompare(product: self.product)
            }
        }
        
        navigation.product.likeButton.clicked { [weak self] in
            guard let self = self,
                  let id = self.product?.id else { return }
                CartViewModel.shared.addFavourites(product: self.product,
                                                   isAdding: !self.isLiked)
        }
        
        cartButton.clicked { [weak self] in
            guard let self = self else { return }
            self.cartPresenter()
        }
    }
    
    func cartPresenter() {
        guard checkVariation(product: self.product) else { return }
        
        if (product?.cart_count ?? 0) > 0 {
            coordinator?.changeCartTab()
        } else {
            MetricEvents.shared.cartEvent(self.product, type: .plus)
            
            CartViewModel.shared.cartChangeCount(productID: product?.id,
                                                 storeID: product?.getStoreID(),
                                                 quantity: 1,
                                                 type: .plus)
            
            coordinator?.presentAddBasket(product: self.product,
                                          viewModel: self.catalogViewModel)
        }
    }
    
    override func initialRequest() {
        loadProduct()
        loadVariations()
        setupCombineObservers()
    }
    
    func loadVariations() {
        if let id = self.product?.id {
            viewModel.loadVariations(productID: id)
        }
    }
    
    func loadCharacteristics() {
        if let id = self.product?.id {
            viewModel.loadProductCharacteristics(id)
        }
    }
    
    func loadProduct() {
        if let id = self.product?.id {
            viewModel.loadProductID(id)
        } else if let alias = self.product?.alias {
            loadProduct(with: alias)
        }

        loadOtherProducts()
    }
    
    func loadBrands() {
        if let id = self.product?.manufacturer?.id {
            brandViewModel.loadBrandCategories(with: id)
        }
    }
    
    func loadReviews() {
        if let id = self.product?.id {
            reviewsViewModel.loadReviews(productID: id)
        }
    }
    
    func loadFAQs() {
        if let id = self.product?.id {
            reviewsViewModel.loadFAQs(productID: id)
        }
    }
    
    func loadReviewFiles() {
        if let id = self.product?.id {
            reviewsViewModel.loadReviewsFiles(productID: id)
        }
    }
        
    func loadProduct(with alias: String) {
        filters.alias = alias
        viewModel.loadProductAlias(alias)
        loadOtherProducts()
    }
    
    func loadPriceHistory() {
        if let id = self.product?.id {
            viewModel.loadProductPriceHistory(id)
        }
    }
    
    func cartButtonState() {
        if (product?.cart_count ?? 0) > 0 {
            cartButton.backgroundColor = .olchaWhite
            cartButton.setIcon(.cart?.withColor(.olchaGreen ?? .green), edgeSize: 8, isIgnoringEdge: false)
        } else {
            cartButton.backgroundColor = .olchaGreen
            cartButton.setIcon(.cart, edgeSize: 8, isIgnoringEdge: false)
        }
    }
    
    func checkIsFavourite() {
        isLiked = product?.is_like ?? false
    }
    
    func checkIsCompared() {
        is_compared = product?.is_compared ?? false
    }
    
    private func loadOtherProducts() {
        guard let alias = product?.alias, alias != "" else { return }
        filters.alias = alias
        catalogViewModel.loadProducts(similarity: .analog, filters: filters)
        catalogViewModel.loadProducts(similarity: .similar, filters: filters)
    }
    
    private func tableReloader(_ section: ProductPage.Sections = .all) {
//        DispatchQueue.main.async { [weak self] in
//            guard let self else { return }
            if section == .all {
                setupScrollViewData()
                //            table.reloadData()
            } else {
                if section.rawValue < sections.count {
                    reloadSection(section: section)
//                    table.reloadSections(IndexSet(integer: section.rawValue), with: .none)
                }
            }
//        }
    }
    
    func emptyVariation(product: ProductModel?, productType: ProductType) {
        coordinator?.presentCartVariation(product: product, productType: productType)
    }
    
    func emptyVariation(product: ProductModel?, productType: ProductType, completion: ((ProductModel?) -> Void)?) {
        coordinator?.presentOpenProductVariation(product: product,
                                                 productType: productType,
                                                 completion: completion)
    }
    
    func compareButton(isAdded: Bool) {
        navigation.product.compareButton.setIcon(isAdded ? .compare?.withColor(.olchaAccentColor) : .compare )
    }
    
    func favouriteButton(isLiked: Bool) {
        navigation.product.likeButton.setIcon(isLiked ? .like_heart_filled : .like_heart)
    }
    
    func fillDatas() {
        if Funcs.hasDiscount(product: product) {
            bottomActionsOldPrice.attributedText = Funcs.getOldPrice(product: product).striked
        } else {
            bottomActionsOldPrice.text = ""
        }
        
        bottomActionsPrice.text = product?.total_price?.price
        
        cartButton.isHidden = !Funcs.isAvailableBasket(fullProduct: fullProduct)
        creditButton.isHidden = !Funcs.isAvailableCredit(fullProduct: fullProduct)
    }
    
    @discardableResult
    func checkVariation(product: ProductModel?, productType: ProductType = .product, withMessage: Bool = true) -> Bool {
        if Funcs.checkAvailableToBuy(
            selectedOptions: helper.selectedOptions,
            combinationOptions: helper.combinationOptions) {
            return true
        } else {
            if withMessage { emptyVariation(product: product, productType: productType) }
            return false
        }
    }
    
    func checkVariation(product: ProductModel?,
                        productType: ProductType = .product,
                        withMessage: Bool = true,
                        completion: ((ProductModel?) -> Void)?) {
        if Funcs.checkAvailableToBuy(
            selectedOptions: helper.selectedOptions,
            combinationOptions: helper.combinationOptions) {
            completion?(product)
        } else {
            if withMessage {
                emptyVariation(product: product,
                               productType: productType,
                               completion: completion)
            } else {
                completion?(nil)
            }
            
        }
    }
}
