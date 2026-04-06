//
//  GroupedProductsView.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 16/05/23.
//

import UIKit
import OlchaUI

public class GroupedProductsView: BaseView {
    private let provider = ProductsCollectionProvider()
    private let spacing: CGFloat = 0
    
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.isScrollEnabled = false
        return collection
    }()
    
    weak var productHelper: ProductHelper? {
        didSet {
            provider.productHelper = productHelper
        }
    }
    weak var skeleton: Skeleton? {
        didSet {
            provider.skeleton = skeleton
        }
    }
    
    let seeAllButton = IButton()
    
    var products: [ProductModel] = [] {
        didSet {
            updateLayout()
        }
    }
    
    public override func setupViews() {
        addSubview(container)
        container.addArrangedSubview(collection)
        container.addArrangedSubview(seeAllButton)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(0)
            make.height.equalTo(Constants.shrinkProductCellHeight * 2 + spacing)
        }
        
        seeAllButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        provider.collection = collection
    }
    
    public func setup(with data: ProductsData?) {
        seeAllButton.designSeeAll()
        self.products = data?.products ?? []
    }
    
    private func updateLayout() {
        provider.configureGroupedLayout(with: products)
        
        if products.count < 4 {
            collection.snp.updateConstraints { $0.height.equalTo(Constants.shrinkProductCellHeight) }
        }
    
    }
    
}

