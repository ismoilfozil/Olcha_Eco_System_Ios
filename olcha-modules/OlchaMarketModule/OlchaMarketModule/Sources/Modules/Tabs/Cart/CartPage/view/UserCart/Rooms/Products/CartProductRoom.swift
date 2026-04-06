//
//  CartProductRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/09/22.
//

import UIKit
import Combine
import OlchaUI
class CartProductRoom: BaseTableCell {
    
    let switchIcon: IconButton = {
        let button = IconButton()
        button.setIcon(.unchecked)
        return button
    }()
    
    private let imageContainer: UIView = {
        let view = UIView()
        view.round(8)
        view.backgroundColor = .olchaLightGray
        return view
    }()
    
    private let productImage = UIImageView()
    
    private let cashbackLabel: Label = {
        let label = Label()
        label.backgroundColor = .olchaLightGreen
        label.horizontalInset = 6
        label.verticalInset = 0
        label.settings.style(.medium, 8)
        label.settings.textColor = .olchaWhite
        label.settings.textColor = .white
        label.round(6.5,
                    topLeftCorner: false,
                    bottomLeftCorner: false,
                    topRightCorner: true,
                    bottomRightCorner: true)
        label.text = ""
        label.isHidden = true
        return label
    }()
    
    private let dataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        return stackView
    }()
    
    private let storeTitle: UILabel = {
        let label = UILabel()
        label.style(.medium, 10)
        label.textColor = .olchaDarkGray
        return label
    }()
    
    private let productTitle: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.numberOfLines = 3
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let productPrice: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textColor = .olchaAccentColor
        return label
    }()
    
    private let oldProductPrice: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    private let cashbackContainer = CashbackView()
    
    private let giftContainer: GiftView = {
        let view = GiftView()
        view.isHidden = true
        return view
    }()
    
    private let separator = Divide()
    
    let likeButton: IconButton = {
        let button = IconButton()
        button.setIcon(.like_heart?.withColor(.olchaLightTextColornnnnnn ?? .gray),
                       isIgnoringEdge: false)
        return button
    }()
    let removeButton: IconButton = {
        let button = IconButton()
        button.setIcon(.x_cancel,
                       isIgnoringEdge: true)
        return button
    }()
    let addCartButton: HorizontalCounterButton = {
        let button = HorizontalCounterButton()
        button.setup(count: 1)
        return button
    }()
    
    let imageSize: CGFloat = 100
    
    var product: ProductModel?
    
    private var bag = Set<AnyCancellable>()
    
    private var isLiked: Bool = false {
        didSet {
            isLiked ? likeButton.setIcon(.heart_filled) : likeButton.setIcon(.unlike)
        }
    }
    
    var isSwitched = false {
        didSet {
            switchIcon.setIcon(isSwitched ? .checked : .unchecked)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
        isSwitched = false
        isLiked = false
    }
    
    override func setupViews() {
        
        container.addSubview(switchIcon)
        container.addSubview(imageContainer)
        imageContainer.addSubview(productImage)
        imageContainer.addSubview(cashbackLabel)
        
        container.addSubview(dataStackView)
        dataStackView.addArrangedSubview(productTitle)
        dataStackView.addArrangedSubview(storeTitle)
        dataStackView.addArrangedSubview(giftContainer)
        dataStackView.addArrangedSubview(oldProductPrice)
        dataStackView.addArrangedSubview(productPrice)
        
        
        container.addSubview(likeButton)
        container.addSubview(removeButton)
        container.addSubview(addCartButton)
        container.addSubview(separator)
    }
    
    override func autolayout() {
        
        switchIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(10)
        }
        
        imageContainer.snp.makeConstraints { make in
            make.width.height.equalTo(imageSize)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        
        productImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        cashbackLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.height.equalTo(14)
        }
        
        dataStackView.snp.makeConstraints { make in
            make.left.equalTo(imageContainer.snp.right).inset(-16)
            make.right.equalTo(switchIcon.snp.left).inset(-2)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalTo(addCartButton.snp.top).inset(-12)
        }
        
        productTitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        storeTitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        giftContainer.snp.makeConstraints { make in
            make.left.equalToSuperview()
        }
        
        oldProductPrice.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        productPrice.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        addCartButton.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().inset(16)
            make.width.equalTo(120)
            make.height.equalTo(36)
        }
        
        removeButton.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.centerY.equalTo(addCartButton.snp.centerY)
        }
        
        likeButton.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.centerY.equalTo(addCartButton.snp.centerY)
            make.right.equalTo(removeButton.snp.left).inset(-16)
            make.left.equalTo(dataStackView.snp.left)
        }
        
    }
    
    override func configureViews() {
    
        likeButton.clicked { [weak self] in
            guard let self = self,
                  let id = self.product?.id else { return }
            CartViewModel.shared.addFavourites(product: self.product, isAdding: !self.isLiked)
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
            .$countClicked
            .sink { [weak self] type in
                guard let self = self,
                      self.product?.cart_count != self.addCartButton.count else { return }
                
                MetricEvents.shared.cartEvent(self.product, type: type)
                
                CartViewModel.shared.cartChangeCount(productID: self.product?.id,
                                                     storeID: self.product?.getStoreID(),
                                                     quantity: self.addCartButton.count,
                                                     type: type,
                                                     loadStoresProducts: false
                )
                
            }.store(in: &bag)
        
        
        CartViewModel
            .shared
            .cartItemChanged
            .sink { [weak self] cartItem in
                guard let self = self else { return }
                
                if cartItem?.product_id == self.product?.id && cartItem?.store_id == self.product?.getStoreID() {
                    self.product?.cart_count = cartItem?.quantity ?? 0
                    self.addCartButton.setup(count: cartItem?.quantity ?? 0)
                }
                
            }.store(in: &bag)
        
        setupSkeleton()
    }
    
    private func setupSkeleton() {
        makeSkeleton(views: [
            productImage,
            productTitle,
            storeTitle,
            productPrice,
            dataStackView,
            addCartButton,
            likeButton,
            removeButton
        ])
    }
    
    func setup(with data: ProductModel?) {
        
        self.product = data
        productImage.load(from: data?.main_image,
                          transition: false,
                          imageType: .equalSize(imageSize))

        productTitle.text = data?.getName()
        productPrice.text = data?.total_price?.price
        
        addCartButton.setup(count: data?.cart_count ?? 0)
        addCartButton.setup(maxCount: data?.quantity?.int ?? Int.max)
        
        isLiked = product?.is_like ?? false
        
        setupCashback(data)
        
        giftContainer.isHidden = data?.gifts?.isEmpty ?? true
        
        storeTitle.text = data?.store?.getName()
    }
    
    func configure(with type: UserCartPage.CartPageType) {
        if type == .credit {
            
            switchIcon.removeFromSuperview()
            addCartButton.removeFromSuperview()
            likeButton.removeFromSuperview()
            removeButton.removeFromSuperview()
            
            dataStackView.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(10)
                make.left.equalTo(productTitle.snp.left)
                make.right.equalToSuperview().inset(16)
                make.bottom.equalTo(separator.snp.top).inset(-12)
            }
        }
    }
    
    func withOldPrice(_ product: ProductModel?) {
        if Funcs.hasDiscount(product: product) {
            productPrice.textColor = .olchaAccentColor
            oldProductPrice.attributedText = Funcs.getOldPrice(product: product).striked
            oldProductPrice.isHidden = false
        } else {
            productPrice.textColor = .olchaTextBlack
            oldProductPrice.text = ""
            oldProductPrice.isHidden = true
        }
    }
    
    func setupCashback(_ product: ProductModel?) {
        
        let cashback = product?.cashback_percent ?? 0
        if (cashback) > 0 {
            cashbackLabel.text = .lang("Кэшбэк \(cashback)%",
                                       "Кэшбэк \(cashback)%",
                                       "Keshbek \(cashback)%")
            cashbackLabel.isHidden = false
        } else {
            cashbackLabel.isHidden = true
        }
    }
}
