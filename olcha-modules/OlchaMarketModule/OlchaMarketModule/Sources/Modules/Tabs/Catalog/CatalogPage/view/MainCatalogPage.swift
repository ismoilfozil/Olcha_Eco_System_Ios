//
//  MainCatalogPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/07/22.
//

import UIKit
import SnapKit
import Combine
import ViewAnimator
import OlchaUI

class MainCatalogPage: BaseViewController {
    
    enum SourceType: Equatable {
        case initial
        case route(api: String)
    }

    
    private let collection = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
    
    private let catalogViewModel = CatalogPageViewModel()
    
    private var bag = Set<AnyCancellable>()
    
    var categories : [CategoryModel] = []
    
    weak var coordinator: CatalogCoordinatorProtocol?
    
    var sourceType: SourceType = .initial
    
    var skeleton = Skeleton(count: 18)
    
    override func setupViews() {
        container.addSubview(collection)
        collection.addSubview(refreshControl)
    }
    
    override func autolayout() {
        collection.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        switch sourceType {
        case .initial:
            navigation.configure(style: .searchAction)
            navigation.searchAction.searchButton.clicked { [weak self] in
                guard let self = self else { return }
                self.coordinator?.pushSearch()
            }
            
            break
        case .route:
            navigation.configure(style: .back)
            break
        }
        
        collection.backgroundColor = .olchaBackgroundColor
        collection.registerClass(forCell: MiniCategoryItem.self)
        collection.delegate = self
        collection.dataSource = self
        
        let manager = CatalogLayoutManager()
        collection.collectionViewLayout = manager.getLayout(with: .mainCatalog)
        
        navigation.searchAction.searchView.setPlaceholder()
    }
    
    override func languageUpdated() {
        
        navigation.searchAction.searchView.setPlaceholder()
        navigationController?.popToRootViewController(animated: true)
        collection.reloadData()
    }
    
    override func setupObservers() {
        self.baseSetupObservers(viewModel: catalogViewModel)
        catalogViewModel
            .$categories
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.categories = data?.parent_categories ?? []
                self.collection.reloadData()
            }.store(in: &bag)
        
        catalogViewModel
            .$routeCategories
            .sink { [weak self] routeCategories in
                guard let self = self else { return }
                self.categories = routeCategories?.1?.categories ?? []
                self.collection.reloadData()
            }.store(in: &bag)
        
        catalogViewModel
            .categoriesIndicator
            .sink { [weak self] isLoading in
                guard let self = self, self.skeleton.isEnabled else { return }
                self.skeleton.isAnimating = isLoading
                self.collection.reloadData()
            }.store(in: &bag)
        
        navigation.searchAction.notificationButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pushNotifications()
        }
    }
    
    override func initialRequest() {
        switch sourceType {
        case .initial:
            catalogViewModel.loadCategories()
            break
        case .route(let api):
            catalogViewModel.loadCategories(index: 0, route: api)
            break
        }
    }
    
    override func refreshList(_ sender: AnyObject) {
        self.skeleton.isEnabled = false
//        categories = []
//        collection.reloadData()
        
            initialRequest()
            refreshControl.endRefreshing()
        
        
    }

}
