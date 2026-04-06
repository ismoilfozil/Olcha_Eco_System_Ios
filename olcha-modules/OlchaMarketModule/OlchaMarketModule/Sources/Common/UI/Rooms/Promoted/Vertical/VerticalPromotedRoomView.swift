//
//  PromotedRoomView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/09/22.
//

import OlchaUI
import UIKit
import Combine
class VerticalPromotedRoomView: UIView, BaseProductCell {
    //MARK: - Private settings
    private let provider = ProductsCollectionProvider()
    
    var isCreditItem = false
    
    private let container = UIStackView()
    
    private let productsCollectionContainer = UIView()
    
    let productsCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let seeAllButton = IButton()
    
    private var products : [ProductModel] = [] {
        didSet {
            reloadCollection()
        }
    }
    
    private var discount : Discount?
    
    var data: ProductsData?
    
    //MARK: - Public settings
    
    var withShowAll = false {
        didSet {
            seeAllButton.isHidden = !withShowAll
        }
    }
    
    var productCellType: ProductCell.CellType = .shrink
    
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
    
    public var topEdge: CGFloat = 16.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        autolayout()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        autolayout()
        configureViews()
    }
    
    func setupViews() {
        addSubview(container)
        container.addArrangedSubview(productsCollectionContainer)
        container.addArrangedSubview(seeAllButton)
        productsCollectionContainer.addSubview(productsCollection)
    }
    
    func configureViews() {
        container.axis = .vertical
        container.alignment = .center
        container.spacing = 16
        container.setCustomSpacing(0, after: productsCollectionContainer)
        
        backgroundColor = .clear
        seeAllButton.designSeeAll()
        
        provider.collection = productsCollection
        productsCollection.isScrollEnabled = false
        
        productsCollectionContainer.backgroundColor = .olchaAccentColor
        productsCollection.backgroundColor = .olchaWhite
        productsCollection.round(12)
        productsCollectionContainer.round(12)
    }
    
    func autolayout() {
        container.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        productsCollectionContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(topEdge)
            make.bottom.equalTo(seeAllButton.snp.top)
            make.height.equalTo(collectionHeight())
        }
        
        productsCollection.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview().inset(12)
        }
        
        seeAllButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
    }
    
    func setup(with data: ProductsData?, maximumLimit: Int = 0) {
        self.data = data
        products = data?.products ?? []
        if maximumLimit > 0 {
            if (products.count) > maximumLimit {
                products = Array(products[0..<maximumLimit])
            }
        }
        
    }
    
    private func background(style: PromotedRoomView.ProductCellStyle) {
        self.backgroundColor = style.color
    }
    
    func configure(style: PromotedRoomView.ProductCellStyle,
                   withShowAll: Bool = false,
                   cellType: ProductCell.CellType,
                   space: CGFloat = 0) {
        self.seeAllButton.designSeeAll()
        self.withShowAll = withShowAll
        self.productCellType = cellType
        
        self.background(style: style)
        self.updateLayout(isVertical: true, space: space)
        
    }
    
    /// ---------- NEED REFACTOR ----------
    private func updateLayout(isVertical: Bool, space: CGFloat) {
        
        self.productsCollectionContainer.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(topEdge)
            make.bottom.equalTo(seeAllButton.snp.top)
            make.height.equalTo(collectionHeight())
        }
        
        if products.isEmpty {
            self.productsCollectionContainer.backgroundColor = .clear
            
            self.productsCollectionContainer.snp.remakeConstraints { make in
                make.left.right.equalToSuperview().inset(16)
                make.top.equalToSuperview()
                make.bottom.equalTo(seeAllButton.snp.top)
                make.height.equalTo(0)
            }
            
            productsCollection.snp.remakeConstraints { make in
                make.top.bottom.left.right.equalToSuperview()
            }
            
        } else {
            productsCollectionContainer.backgroundColor = .olchaAccentColor
            
            productsCollection.snp.remakeConstraints { make in
                make.top.bottom.left.right.equalToSuperview().inset(12)
            }
        }
        
        self.provider.isCreditItem = isCreditItem
        
        self.provider.configure(with: self.products,
                                cellType: self.productCellType,
                                isVertical: isVertical,
                                space: space)
        
        self.productsCollection.alwaysBounceVertical = false
        
    }
    
    func reloadCollection() {
        productsCollection.reloadData()
    }
    
    private func collectionHeight() -> CGFloat {
        ///
        ///cell
        /// |
        ///-12-
        /// |
        ///cell
        ///
        let edgeBetweenCells: CGFloat = 12
        ///top bottom edge = 12
        let collectionEdge: CGFloat = 24.0
        
        
        let productsHeight = CGFloat(products.count) * Constants.expandProductCellHeight
        let edgeProductsHeight = edgeBetweenCells * CGFloat(products.count - 1)
        
        let collectionHeight = collectionEdge + productsHeight + edgeProductsHeight
        
        return collectionHeight
    }
}
