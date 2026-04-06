//
//  FavouritesPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/09/22.
//

import UIKit
import Combine
import OlchaCore
class FavouritesPage: BaseViewController {
    
    let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var products: [ProductModel] = []
    
    private var paging = Paging()
    
    private let viewModel = CartViewModel()
    
    private var bag = Set<AnyCancellable>()
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    var strongCoordinator: ProfileCoordinatorProtocol?
    
    let favouriteObserver = PassthroughSubject<Bool, Never>()
    
    let productHelper = ProductHelper()
    
    var isTabPage: Bool = false {
        didSet {
            configureNavigationBar()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(collection)
    }
    
    override func autolayout() {
        super.autolayout()
        collection.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
    override func configureViews() {
        super.configureViews()
        super.likeToastEnabled = false
        configureNavigationBar()
        
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .olchaBackgroundColor
        collection.registerClass(forCell: ProductCell.self)
        collection.showsVerticalScrollIndicator = false
        
        
        if let layout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            
            collection.collectionViewLayout = layout
            
        }
        if coordinator == nil {
            guard let navigationController = self.navigationController else { return }
            strongCoordinator = ProfileCoordinator(navigationController: navigationController)
        }
        languageUpdated()
    }
    
    override func languageUpdated() {
        placeholder.setupTitle("empty_favourites".localized())
        placeholder.setupSubtitle("empty_favourites_subtitle".localized())
        placeholder.setupButtonTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        paging = .init()
        products.removeAll()
        
        loadProducts()
    }
    
    override func initialRequest() {
        super.initialRequest()

    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        productHelper
            .pushParentProduct
            .sink { [weak self] data in
                guard let self = self else { return }
                getCoordinator()?.presentCartVariation(product: data, productType: .product)
            }.store(in: &bag)
        
        productHelper
            .pushProduct
            .sink { [weak self] data in
                guard let self else { return }
                getCoordinator()?.pushProduct(product: data)
            }.store(in: &bag)
        
        viewModel
            .$favouriteProducts
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                
                paging.finished(paginator: data?.paginator)
                
                products.append(data?.products, paging)
                
                reloadCollection()
            }.store(in: &bag)
        
        viewModel
            .$favouriteProductsError
            .sink { [weak self] isError in
                guard let self = self, isError else { return }
                self.paging.isLoading = false
                self.paging.current -= 1
            }.store(in: &bag)
        
        CartViewModel
            .shared
            .$favouriteChangedID
            .sink { [weak self] productID in
                guard let self = self, productID != nil else { return }
//                self.paging = .init()
//                self.products.removeAll()
            }.store(in: &bag)
        
        CartViewModel
            .shared
            .favouritesReload
            .sink { [weak self] isReload in
                guard let self = self, isReload else { return }
                
                paging = .init()
                products.removeAll()
                
                loadProducts()
            }.store(in: &bag)
        
        
        viewModel
            .favouriteLoading
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.showCenterProgress() : self.hideCenterProgress()
            }.store(in: &bag)
        
        placeholderButton { [weak self] in
            guard let self = self else { return }
            popToMainTab(mainTabIndex: OlchaTab.home)
        }
    }
    
    func reloadCollection() {
        products.isEmpty ? enablePlaceholder() : disablePlaceholder()
        collection.reloadData()
    }
    
    func loadProducts() {
        
        if !paging.isLoading {
            paging.isLoading = true
            viewModel.loadFavourites(page: paging.current)
        }
        
    }
    
    func checkPaginator(index: Int) {
        if index == (products.count - 3) {
            if !paging.isLoading {
                paging.current = paging.current + 1
                if paging.current <= paging.total {
                    loadProducts()
                }
            }
        }
    }
    
    func configureNavigationBar() {
        if isTabPage {
            navigation.configure(style: .center)
        } else {
            navigation.configure(style: .back)
        }
        navigation.setTitle("favourites".localized())
    }
    
    func getCoordinator() -> ProfileCoordinatorProtocol? {
        if let coordinator = coordinator {
            return coordinator
        } else {
            return strongCoordinator
        }
    }
}

