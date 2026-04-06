//
//  PromotedRoomView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/09/22.
//

import OlchaUI
import UIKit
import Combine
class PromotedRoomView: UIView, BaseProductCell {
    //MARK: - Private settings
    private let provider = ProductsCollectionProvider()
    
    var isCreditItem = false
    
    enum ProductCellStyle {
        case white
        case gray
        case lightGray
        
        var color: UIColor? {
            switch self {
            case .white:
                return .olchaBackgroundColor
            case .gray:
                return .olchaLightNeutralGray
            case .lightGray:
                return .olchaLightNeutralGray
            }
        }
    }
    
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
        
    }
    
    func autolayout() {
        container.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        productsCollectionContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(topEdge)
            make.bottom.equalTo(seeAllButton.snp.top)
            make.height.equalTo(Constants.shrinkProductCellHeight)
        }
        
        productsCollection.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
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
    
    private func background(style: ProductCellStyle) {
        self.backgroundColor = style.color
    }
    
    func configure(style: ProductCellStyle,
                   withShowAll: Bool = false,
                   cellType: ProductCell.CellType,
                   space: CGFloat = 0
    ) {
        self.seeAllButton.designSeeAll()
        self.withShowAll = withShowAll
        self.productCellType = cellType
        
        self.background(style: style)
        self.updateLayout(isVertical: cellType == .expand, space: space)
        
    }
    
    /// ---------- NEED REFACTOR ----------
    private func updateLayout(isVertical: Bool, space: CGFloat) {
        self.productsCollectionContainer.backgroundColor = isVertical ? .olchaAccentColor : .clear
        self.productsCollection.backgroundColor = isVertical ? .olchaWhite : .clear
        self.productsCollection.round(isVertical ? 12 : 0)
        self.productsCollectionContainer.round(isVertical ? 12 : 0)
        
        self.productsCollectionContainer.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(isVertical ? 16 : 0)
            make.top.equalToSuperview().inset(topEdge)
            make.bottom.equalTo(seeAllButton.snp.top)
            if isVertical {
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
                
                make.height.equalTo(collectionHeight)
            } else {
                make.height.equalTo(Constants.shrinkProductCellHeight)
            }
        }
        
        productsCollection.snp.remakeConstraints { make in
            make.top.bottom.left.right.equalToSuperview().inset(isVertical ? 12 : 0)
        }
        
        if products.isEmpty && isVertical {
            self.productsCollectionContainer.backgroundColor = .clear
            
            self.productsCollectionContainer.snp.remakeConstraints { make in
                make.left.right.equalToSuperview().inset(isVertical ? 16 : 0)
                make.top.equalToSuperview()
                make.bottom.equalTo(seeAllButton.snp.top)
                make.height.equalTo(0)
            }
            
            productsCollection.snp.remakeConstraints { make in
                make.top.bottom.left.right.equalToSuperview()
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
}
