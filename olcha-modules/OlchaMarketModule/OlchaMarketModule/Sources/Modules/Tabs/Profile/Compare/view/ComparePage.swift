//
//  ComparePage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/08/22.
//

import UIKit
import Combine
import OlchaUI
class ComparePage: BaseViewController {
    
    struct HEIGHTS {
        static let expanded_header: CGFloat = 280
        static let shrinked_header: CGFloat = 132
        
        static let categories_collection: CGFloat = 32
        static let categories_collection_top_margin: CGFloat = 16
        static let actions_container: CGFloat = 24
        static let actions_container_top: CGFloat = 16
        static let actions_container_bottom: CGFloat = 16
        static var categories_container : CGFloat {
            var height = categories_collection
            height += categories_collection_top_margin
            height += actions_container
            height += actions_container_top
            height += actions_container_bottom
            return height
        }
    }

    private var bag = Set<AnyCancellable>()
    
    let viewModel = CompareViewModel.shared
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    var strongCoordinator: ProfileCoordinatorProtocol?
    
    let headerContainer = UIView()
    
    let table = UITableView()
    
    let categoriesContainer = UIView()
    
    lazy var categoriesCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = .zero
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
        
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .olchaBackgroundColor
        collection.registerClass(forCell: CompareCategoryCell.self)
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        return collection
    }()
    
    let topActionsScrollView = UIScrollView()
    let addProductButton = LeftIconButton()
    let clearCategoryButton = LeftIconButton()
    
    private let collectionsContainer = UIView()
    
    lazy var leftProductsCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.registerClass(forCell: CompareProductCell.self)
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    lazy var rightProductsCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.registerClass(forCell: CompareProductCell.self)
        collection.isPagingEnabled = true
        
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()
    
    private let headerSeparator = UIView()
    private let headerBottomSeparator = UIView()
    
    var allProducts: [ProductModel] = []
    
    var compareGroupModels: [CompareGroupModel] = []  {
        didSet {
            checkPlaceholder()
        }
    }
    
    var product: ProductModel?
    
    var features: [FeatureData] = []
    
    var leftProduct: ProductModel?
    
    var rightProduct: ProductModel? {
        didSet {
            loadOptions()
        }
    }
    
    var selectedCategory: CategoryModel? {
        didSet {
            getIndex()
            filterProductsWithCategory()
        }
    }
    
    private var _selectedIndex: Int?
    var selectedIndex: Int? {
        get {
            if let _selectedIndex, compareGroupModels.isGreater(_selectedIndex) {
                return _selectedIndex
            } else {
                return nil
            }
        }
        
        set {
            _selectedIndex = newValue
        }
    }
    
    let productHelper = ProductHelper()
    
    var isLoading: Bool = true
    
    override func setupViews() {
        super.setupViews()
        
        container.addSubview(table)
        container.addSubview(categoriesContainer)
        
        categoriesContainer.addSubview(categoriesCollection)
        categoriesContainer.addSubview(topActionsScrollView)
        topActionsScrollView.addSubview(addProductButton)
        topActionsScrollView.addSubview(clearCategoryButton)
        
        container.addSubview(headerContainer)
        headerContainer.addSubview(collectionsContainer)
        
        collectionsContainer.addSubview(leftProductsCollection)
        collectionsContainer.addSubview(rightProductsCollection)
        collectionsContainer.addSubview(headerSeparator)
        collectionsContainer.addSubview(headerBottomSeparator)
    }
    
    override func autolayout() {
        super.autolayout()
        
        categoriesContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(HEIGHTS.categories_container)
        }
        
        topActionsScrollView.snp.makeConstraints { make in
            make.top.equalTo(categoriesCollection.snp.bottom).inset(-HEIGHTS.actions_container_top)
            make.height.equalTo(HEIGHTS.actions_container)
            make.left.right.equalToSuperview()
        }
        
        addProductButton.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(HEIGHTS.actions_container)
        }
        
        clearCategoryButton.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.left.equalTo(addProductButton.snp.right).inset(-16)
            make.right.equalToSuperview()
            make.height.equalTo(HEIGHTS.actions_container)
        }
        
        categoriesCollection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(HEIGHTS.categories_collection_top_margin)
            make.height.equalTo(HEIGHTS.categories_collection)
        }
        
        headerContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(HEIGHTS.categories_container)
            make.height.equalTo(HEIGHTS.expanded_header)
        }
        
        collectionsContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        
        table.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        leftProductsCollection.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        rightProductsCollection.snp.makeConstraints { make in
            make.right.bottom.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        headerSeparator.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalTo(1)
        }
        
        headerBottomSeparator.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func configureViews() {
        super.configureViews()
        viewModel.comparedProducts = []
        compareToastEnabled = false
        navigation.configure(style: .back)
        navigation.setTitle("compare_products".localized())
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: CompareOptionRoom.self)
        table.configure()
        table.showsVerticalScrollIndicator = false
        
        table.contentInset = .init(top: HEIGHTS.expanded_header + HEIGHTS.categories_container, left: 0, bottom: 16, right: 0)
        table.setContentOffset(
            .init(x: 0,
                  y: -(HEIGHTS.expanded_header + HEIGHTS.categories_container)),
            animated: true)
        
        headerSeparator.backgroundColor = .olchaLightNeutralDarkGray
        headerBottomSeparator.backgroundColor = .olchaLightNeutralDarkGray
        headerContainer.backgroundColor = .olchaWhite
        
        topActionsScrollView.showsHorizontalScrollIndicator = false
        addProductButton.setTitle("add_products".localized())
        addProductButton.titleLabel.textColor = .olchaBlue
        addProductButton.titleLabel.style(.medium, 14)
        addProductButton.setIcon(.plus_blue)
        
        clearCategoryButton.setTitle("clear_categories".localized())
        clearCategoryButton.titleLabel.textColor = .olchaBlue
        clearCategoryButton.titleLabel.style(.medium, 14)
        clearCategoryButton.setIcon(.trash_blue)
        
        if coordinator == nil {
            guard let navigationController = self.navigationController else { return }
            strongCoordinator = ProfileCoordinator(navigationController: navigationController)
        }
        
        languageUpdated()
        checkPlaceholder()
    }
    
    override func languageUpdated() {
        placeholder.setupTitle("empty_compare".localized())
        placeholder.setupSubtitle("empty_compare_subtitle".localized())
        placeholder.setupButtonTitle()
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        
        viewModel
            .$comparedProducts
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] products in
                guard let self = self, let products else { return }
                self.isLoading = false
//                loaderState(false)
                self.allProducts = products
                self.groupProducts()
            }.store(in: &bag)
        
        viewModel
            .$featuresData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                loaderState(false)
                self.features = data?.features ?? []
                self.reloadAll()
            }.store(in: &bag)
        
        
        clearCategoryButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.removeCategory()
            self.removeSelectedCategory()
            self.reloadAll()
            self.forceLoadOptions()
        }
        
        addProductButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            if self.selectedCategory != nil {
                self.getCoordinator()?.pushProductList(category: self.selectedCategory)
            }
        }
        
        placeholderButton { [weak self] in
            guard let self = self else { return }
            popToMainTab(mainTabIndex: OlchaTab.home)
        }
        
        productHelper
            .pushParentProduct
            .sink { [weak self] data in
                guard let self = self else { return }
                self.getCoordinator()?.presentCartVariation(product: data, productType: .product)
            }.store(in: &bag)
    }
    
    override func initialRequest() {
        super.initialRequest()
        loadProducts()
    }
    
    private func groupProducts() {
        var categoriesDict : [Int: CategoryModel] = [:]
        var compareGroupsDict : [Int: CompareGroupModel] = [:]
        for product in allProducts {
            if let category = product.category,
               let id = category.id {
                categoriesDict[id] = category
                
                if var model = compareGroupsDict[id] {
                    model.products.append(product)
                    compareGroupsDict[id]?.products = model.products
                } else {
                    let model = CompareGroupModel(category: category, products: [product])
                    compareGroupsDict[id] = model
                }
            }
        }
        
        compareGroupModels = Array(compareGroupsDict.values)
        
        let newSelectedCategory = allProducts.first?.category ?? compareGroupModels.first?.categroy
        
        if let index = compareGroupModels.firstIndex(where: { $0.categroy?.id == newSelectedCategory?.id }) {
            compareGroupModels.swapAt(0, index)
        }
        
        selectedCategory = newSelectedCategory
       
        tableReloader()
    }
    
    func loadOptions() {
        if let leftProduct = leftProduct,
           let rightProduct = rightProduct {
            loaderState(true)
            viewModel.loadCompareProductFeatures(products: [leftProduct, rightProduct])
        }
    }
    
    
    func reloadAll() {
        tableReloader()
        leftProductsCollection.reloadData()
        rightProductsCollection.reloadData()
        categoriesCollection.reloadData()
    }
    
    func forceLoadOptions(nextItem: Bool = false) {
        
        guard let selectedIndex = selectedIndex,
              compareGroupModels.isGreater(selectedIndex),
              !compareGroupModels[selectedIndex].products.isEmpty else {
                  features.removeAll()
                  tableReloader()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            guard let self = self,
                  compareGroupModels.isGreater(selectedIndex) else { return }
            let category = self.compareGroupModels[selectedIndex]
            
            if var rightPage = self.rightProductsCollection.indexPathsForVisibleItems.first?.item,
               let leftPage = self.leftProductsCollection.indexPathsForVisibleItems.first?.item {
                
                rightPage = actualRightPage(loadNextProduct: nextItem,
                                            list: category.products,
                                            index: rightPage)
                
                self.leftProduct = category.products[leftPage]

                self.rightProduct = category.products[rightPage]
                
                self.rightProductsCollection.scrollToItem(
                    at: .init(item: rightPage,
                              section: 0),
                    at: .centeredHorizontally,
                    animated: false
                )
            }
        }
        
    }
    
    func actualRightPage(loadNextProduct: Bool, list: [Any], index: Int) -> Int {
        loadNextProduct ? min(list.count - 1, index + 1) : index
    }
    
    func filterProductsWithCategory() {
        reloadAll()
        forceLoadOptions(nextItem: true)
    }
    
    
    func removeItem(at index: Int) {
        
        guard let selectedIndex = selectedIndex,
              compareGroupModels.isGreater(selectedIndex) else {
            return
        }
        
        compareGroupModels[selectedIndex].products.remove(at: index)
        
        if compareGroupModels[selectedIndex].products.isEmpty {
            removeSelectedCategory()
        }
        
        reloadAll()
        forceLoadOptions()
    }
    
    func removeSelectedCategory() {
        features.removeAll()
        
        guard let selectedIndex = selectedIndex,
              compareGroupModels.isGreater(selectedIndex)
        else { return }
        
        
        compareGroupModels.remove(at: selectedIndex)
        
        if (0..<compareGroupModels.count) ~= selectedIndex {
            selectedCategory = compareGroupModels[selectedIndex].categroy
            categoriesCollection.scrollToItem(at: .init(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
        } else if (0..<compareGroupModels.count) ~= (selectedIndex-1) {
            selectedCategory = compareGroupModels[selectedIndex-1].categroy
            categoriesCollection.scrollToItem(at: .init(item: selectedIndex-1, section: 0), at: .right, animated: false)
        } else {
            selectedCategory = nil
        }
        
    }
    
    private func tableReloader() {
        table.reloadData()
        checkContentHeight()
    }
    
    private func getIndex() {
        selectedIndex = compareGroupModels.firstIndex(where: { $0.categroy?.id == selectedCategory?.id })
    }
    
    private func checkContentHeight() {
        let bottomInset = container.frame.height - table.contentSize.height - HEIGHTS.shrinked_header + 24.0

        table.contentInset = .init(top: HEIGHTS.expanded_header + HEIGHTS.categories_container, left: 0, bottom: max(0, bottomInset), right: 0)
    }
    
    private func removeCategory() {
        guard let selectedIndex = selectedIndex, compareGroupModels.isGreater(selectedIndex) else { return }
        viewModel.removeCompare(category: compareGroupModels[selectedIndex].categroy,
                                products: compareGroupModels[selectedIndex].products)
    }
    
    func getCoordinator() -> ProfileCoordinatorProtocol? {
        return coordinator ?? strongCoordinator
    }
    
    func loaderState(_ isLoading: Bool) {
        print("check loading", isLoading)
        isLoading ? showPostProgress() : hidePostProgress()
    }
    
    private func loadProducts() {
        self.isLoading = true
        loaderState(true)
        viewModel.loadCompareProducts()
    }
    
    func checkPlaceholder() {
        if compareGroupModels.isEmpty {
            if isLoading {
                topActionsScrollView.isHidden = true
                collectionsContainer.isHidden = true
            } else {
                enablePlaceholder()
            }
        } else {
            topActionsScrollView.isHidden = false
            collectionsContainer.isHidden = false
            disablePlaceholder()
        }
    }
}
