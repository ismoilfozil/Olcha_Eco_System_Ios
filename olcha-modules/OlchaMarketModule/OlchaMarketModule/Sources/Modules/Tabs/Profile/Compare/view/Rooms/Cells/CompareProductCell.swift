//
//  CompareProductCell.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/08/22.
//

import UIKit
import Combine
import OlchaUI
class CompareProductCell: BaseCollectionCell {
    
    enum CellType {
        case shrink
        case expand
    }
    
    
    
    //MARK: - UI ELEMENTS
    
    
    private let imageContainer = UIView()
    private let productImageView = UIImageView()
    private let adultChecker = AdultChecker(withTitle: true)
    private let datasContainer = UIView()
    private let soldContainer = SoldContainer()
    
    
    private let productTitleContainer = UIView()
    private let productTitle = UITextView()
    private let priceStackView = UIStackView()
    private let productOldPrice = UILabel()
    private let productPrice = UILabel()
    private let addCartButton: CartButton = CircleCartButton()
    
    let productPermonthPriceStack: UIStackView = {
        let stackView = UIStackView()
        stackView.isHidden = true
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 2, left: 4, bottom: 2, right: 4)
        stackView.backgroundColor = .olchaLightYellow
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.round(6)
        return stackView
    }()
    
    let productPermonthPrice: Label = {
        let label = Label()
        label.settings.style(.semibold, 10.0)
        label.settings.textColor = .olchaTextBlack
        label.isHidden = true
        label.text = " "
        label.verticalInset = 0
        return label
    }()
    
    private let paginator = UILabel()
    private let topPaginator = UILabel()
    
    let likeButton: IconButton = {
        let button = IconButton()
        button.setIcon(.unliked)
        button.backgroundColor = .olchaWhite
        button.round(14)
        return button
    }()
    let removeButton = IconButton()
    
    private var bag = Set<AnyCancellable>()
    //MARK: - PROPERTIES
    
    private var product: ProductModel?
    
    private var isLiked: Bool = false {
        didSet {
            likeButton.setIcon(isLiked ? .liked : .unliked)
            product?.is_like = isLiked
        }
    }
    
    weak var productHelper: ProductHelper?
    
    let imageSize: CGFloat = 120
    
    func setup(with data: ProductModel?) {
        self.product = data
        
        self.isLiked = data?.is_like ?? false
        
        
        self.productImageView.load(from: data?.main_image,
                                   imageType: .equalSize(imageSize))
        self.productTitle.text = data?.getName()
        self.productTitle.sizeToFit()
        if Funcs.hasDiscount(product: data) {
            self.productOldPrice.attributedText = Funcs.getOldPrice(product: data).striked
            self.productOldPrice.isHidden = false
            self.productPrice.textColor = .olchaAccentColor
        } else {
            self.productOldPrice.text = ""
            self.productOldPrice.isHidden = true
            self.productPrice.textColor = .olchaTextBlack
        }
        self.productPrice.text = data?.total_price?.price

        checkCartButtonStack()
        calculateCreditText()
        adultChecker.check(data)
    }
    
    func setup(page: Int, totalPage: Int) {
        let paginatorText: String = .lang("\(page) - \(totalPage)",
                                          "\(page) - \(totalPage)",
                                          "\(page) - \(totalPage)")
        paginator.text = paginatorText
        topPaginator.text = paginatorText
    }
    
    override func cellWillAppear() {
        checkCartButtonStack()
    }
    
    private func checkCartButtonStack() {
        addCartButton.countButton.count = product?.cart_count ?? 0
        addCartButton.countButton.maxCount = product?.quantity?.int ?? Int.max
        
        let outOfStock = product?.out_of_stock ?? false
        let isParent = product?.isParentProduct() ?? false
        addCartButton.checkButtonStates(isSold: outOfStock, isParentProduct: isParent)
        if outOfStock {
            soldContainer.isHidden = false
            soldContainer.isUserInteractionEnabled = true
        } else {
            soldContainer.isHidden = true
            soldContainer.isUserInteractionEnabled = false
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let offset = ComparePage.HEIGHTS.expanded_header - ComparePage.HEIGHTS.shrinked_header
        let percent = (self.bounds.height - ComparePage.HEIGHTS.shrinked_header) / offset

        
        shrink(percent: percent)
    }
    
    override func setupViews() {
        
        container.addSubview(imageContainer)
        
        
        addSubview(likeButton)
        addSubview(removeButton)
        container.addSubview(datasContainer)
        datasContainer.addSubview(productTitleContainer)
        productTitleContainer.addSubview(productTitle)
        datasContainer.addSubview(priceStackView)
        
        priceStackView.addArrangedSubview(productOldPrice)
        priceStackView.addArrangedSubview(productPrice)
        
        container.addSubview(addCartButton)
        imageContainer.addSubview(productImageView)
        imageContainer.addSubview(adultChecker)
        addSubview(paginator)
        addSubview(topPaginator)
        
        addSubview(soldContainer)
        
        priceStackView.addArrangedSubview(productPermonthPriceStack)
        
        productPermonthPriceStack.addArrangedSubview(productPermonthPrice)
    }
    
    override func configureViews() {
        likeButton.setIcon(.unliked)
        
        removeButton.setIcon(.trash_circle)
        removeButton.round(14)
        
        
        productTitle.font = .style(.semibold, 14)
        productImageView.contentMode = .scaleAspectFit
        productTitle.textColor = .olchaTextBlack
        productTitle.textContainer.lineBreakMode = .byTruncatingTail
        productTitle.disable()
        
        productOldPrice.style(.medium, 12.0)
        productOldPrice.textColor = .olchaLightTextColornnnnnn
        
        productPrice.style(.semibold, 12)
        
        priceStackView.axis = .vertical
        priceStackView.spacing = 4
        
        paginator.textColor = .olchaLightTextColornnnnnn
        paginator.style(.medium, 12)
        paginator.text = " - "
        
        topPaginator.textColor = .olchaLightTextColornnnnnn
        topPaginator.style(.medium, 12)
        
        topPaginator.isHidden = true
        topPaginator.alpha = 0
        
        staticTexts()
        
        
        setupObservers()
    }
    
    private func setupObservers() {
        likeButton.clicked { [weak self] in
            guard let self = self,
                  let id = self.product?.id else { return }
            CartViewModel.shared.addFavourites(product: self.product, isAdding: !self.isLiked)
            if !self.isLiked {
                MetricEvents.shared.addToFavourites(self.product)
            }
        }
        
        CartViewModel
            .shared
            .$favouriteChangedID
            .sink { [weak self] productID in
                guard let self = self,
                      let productID = productID else { return }
                if productID == self.product?.id {
                    self.isLiked = !self.isLiked
                    self.product?.is_like = self.isLiked
                }
            }.store(in: &bag)
        
        addCartButton
            .countButton
            .$countClicked
            .sink { [weak self] type in
                guard let self = self,
                      self.product?.cart_count != self.addCartButton.count else { return }
                
                MetricEvents.shared.cartEvent(self.product, type: type)
                
                CartViewModel.shared.cartChangeCount(productID: self.product?.id,
                                                     storeID: self.product?.getStoreID(),
                                                     quantity: self.addCartButton.count,
                                                     type: type)
                
            }.store(in: &bag)
        
        CartViewModel
            .shared
            .cartItemChanged
            .sink { [weak self] cartItem in
                guard let self = self else { return }
                if cartItem?.product_id == self.product?.id && cartItem?.store_id == self.product?.getStoreID() {
                    self.product?.cart_count = cartItem?.quantity ?? 0
                    self.addCartButton.countButton.count = cartItem?.quantity ?? 0
                }
            }.store(in: &bag)
        
        addCartButton
            .parentPush
            .sink { [weak self] isPushing in
                guard let self = self, isPushing else { return }
                self.productHelper?.pushParentProduct.send(self.product)
            }.store(in: &bag)
    }
    
    override func autolayout() {
        
        imageContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.width.height.equalTo(imageSize)
            make.centerX.equalToSuperview()
        }
        
        adultChecker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        productImageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        datasContainer.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.right.equalTo(addCartButton.snp.left).inset(-4)
            make.top.equalTo(imageContainer.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        productTitleContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(50)
        }
        
        priceStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.lessThanOrEqualTo(productTitleContainer.snp.bottom).inset(-12).priority(.low)
            make.bottom.equalToSuperview().inset(16)
        }

        productTitle.snp.makeConstraints { make in
            make.bottom.left.right.top.equalToSuperview()
        }
        
        addCartButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(16)
        }

        likeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.right.equalToSuperview().inset(4)
            make.width.height.equalTo(28)
        }
        
        removeButton.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).inset(-8)
            make.right.equalToSuperview().inset(4)
            make.width.height.equalTo(28)
        }
        
        paginator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
            make.top.equalTo(container.snp.bottom).inset(-4)
            make.height.equalTo(12)
        }
        
        topPaginator.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(8)
        }
        
        soldContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func shrink(percent: CGFloat) {
        
        likeButton.isHidden = (percent != 1)
        removeButton.isHidden = (percent != 1)
        
        addCartButton.alpha = percent
        priceStackView.alpha = percent
        paginator.alpha = percent
        topPaginator.alpha = (1-percent)
        
        
        priceStackView.isHidden = (percent < 0.6)
        addCartButton.isHidden = (percent < 0.4)
        
        paginator.isHidden = (percent < 0.2)
        
        topPaginator.isHidden = (percent > 0.2)
        
        let height = min(120, max(56, 120 * percent))
        
        
        imageContainer.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.width.height.equalTo(height)
            if percent == 1 {
                make.left.centerX.equalToSuperview()
            } else {
                make.left.equalToSuperview().inset(12)
            }
        }
    }
 
    func staticTexts() {
        addCartButton.setup()
    }
    
    func calculateCreditText() {
        
        productPermonthPriceStack.isHidden = true
        productPermonthPrice.isHidden = true
        
        if let repayment = product?.monthly_repayment,
           let month_period = product?.plan?.max_period {
            productPermonthPrice.settings.textAlignment = .center
            productPermonthPriceStack.isHidden = false
            productPermonthPrice.isHidden = false
            productPermonthPrice.text = repayment.string.price + " x" + month_period
        }
        
        let month = Funcs.creditMonth(product: self.product)
        
        if month > 0 {
            productPermonthPriceStack.isHidden = false
        }
        
    }
}
