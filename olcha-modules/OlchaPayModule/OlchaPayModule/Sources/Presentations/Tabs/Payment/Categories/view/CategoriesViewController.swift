//
//  CategoriesViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 27/03/23.
//

import UIKit
import OlchaUI
public class CategoriesViewController: BaseViewController<TitleNavigationBar> {
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: CategoryItem.self)
        collection.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        collection.registerClass(forHeader: CategoryHeader.self, kind: UICollectionView.elementKindSectionHeader)
        collection.alwaysBounceVertical = true
        return collection
    }()
    
    let sections: [Section] = [
        .urgent,
        .categories
    ]
    
    var categories: [CategoryModel] = [] {
        didSet {
            collection.reloadData()
        }
    }
    
    var skeleton = Skeleton(count: 15)
    
    weak var coordinator: PaymentsCoordinatorProtocol?
    
    let viewModel: PaymentsViewModel
    
    public init(viewModel: PaymentsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViews()
    }
    
    public override func setupViews() {
        container.addSubview(collection)
        collection.addSubview(refreshControl)
    }
    
    public override func autolayout() {
        collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        navigationBar.setTitle("categories".localized())
        
        container.backgroundColor = .olchaLightNeutralGray
        view.backgroundColor = .olchaLightNeutralGray
        collection.backgroundColor = .olchaLightNeutralGray
        navigationBar.withSearch = true
        navigationBar.backButton.isHidden = true
    }
    
    public override func setupObservers() {
        handle(viewModel.$categories) { [weak self] data in
            guard let self = self, let data else { return }
            self.categories = data.getCategories()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showError(text: error?.message)
        } loading: { [weak self] isLoading in
            guard let self else { return }
            skeleton.isAnimating = isLoading
            self.collection.reloadData()
        }
        
        navigationBar.searchButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pushSearch(categoryID: nil)
        }
    }
    
    public override func initialRequest() {

        if viewModel.categories == .standart {
            viewModel.loadCategories()
        }
        
    }
    
    public override func refreshList(_ sender: AnyObject) {
        categories = []
        refreshControl.endRefreshing()
        initialRequest()
    }
    
    public override func languageUpdated() {
        collection.reloadData()
        navigationBar.setTitle("categories".localized())
    }
}
