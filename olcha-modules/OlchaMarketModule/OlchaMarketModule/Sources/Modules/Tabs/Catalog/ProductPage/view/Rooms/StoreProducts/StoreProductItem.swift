//
//  StoreProduct.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 27/07/22.
//

import UIKit
import Combine
import OlchaUI
class StoreProductItem: BaseTableCell {
    
    enum Position {
        case top
        case middle
        case bottom
        case single
    }

    private let price = UILabel()
    private let oldPrice = UILabel()
    private let additionalContainer = UIStackView()
    private let giftTable = DynamicTable()
    
    private let warrantyContainer = UIView()
    private let warrantyTitle = UILabel()
    private let warrantyValue = UILabel()
    
    private let locationContainer = UIView()
    private let locationIcon = UIImageView()
    private let locationTitle = UILabel()
    
    private let shippingType = UILabel()
    private let shippingTime = UILabel()
    private let link = Button()
    let addCartButton = CartButton()
    let parentProductButton = IButton()
    private let separator = Divide()
    private var position: Position = .middle
    private var bag = Set<AnyCancellable>()
    @Published var count = 0
    
    var storeProduct: StoreProductsData?
    var product: ProductModel?
    
    weak var pushStoreObserver: PassthroughSubject<Store?, Never>?
    weak var parentObserver: PassthroughSubject<ProductModel?, Never>?
    
    override func setupViews() {
        clipsToBounds = true
        container.addSubview(price)
        container.addSubview(oldPrice)
        container.addSubview(additionalContainer)
        additionalContainer.addArrangedSubview(locationContainer)
        
        locationContainer.addSubview(locationIcon)
        locationContainer.addSubview(locationTitle)
        
        additionalContainer.addArrangedSubview(giftTable)
        
        additionalContainer.addArrangedSubview(warrantyContainer)
        warrantyContainer.addSubview(warrantyTitle)
        warrantyContainer.addSubview(warrantyValue)
        
        container.addSubview(shippingType)
        container.addSubview(shippingTime)
        container.addSubview(link)
        container.addSubview(addCartButton)
        container.addSubview(parentProductButton)
        container.addSubview(separator)
    }
    
    override func autolayout() {
        container.snp.remakeConstraints { make in
            make.right.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(-2)
        }
        
        price.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
        }
        
        oldPrice.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(price)
            make.left.equalTo(price.snp.right).inset(-4)
        }
        
        additionalContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(price.snp.bottom).inset(-4)
        }
        
        giftTable.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(100)
        }
        
        warrantyTitle.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        
        warrantyValue.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(warrantyTitle.snp.right).inset(-8)
        }
        
        locationIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.top.bottom.greaterThanOrEqualToSuperview()
            make.left.equalToSuperview()
        }
        
        locationTitle.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(4)
            make.left.equalTo(locationIcon.snp.right).inset(-4)
        }
        
        shippingType.snp.makeConstraints { make in
            make.top.equalTo(additionalContainer.snp.bottom).inset(-8)
            make.left.equalTo(price)
            make.right.equalToSuperview().inset(16)
        }
        
        shippingTime.snp.makeConstraints { make in
            make.top.equalTo(shippingType.snp.bottom)
            make.left.equalTo(price)
            make.right.equalToSuperview()
            make.bottom.equalTo(addCartButton.snp.top).inset(-8)
        }
        
        link.snp.makeConstraints { make in
            make.bottom.equalTo(addCartButton.snp.bottom)
            make.left.equalTo(price)
            make.right.lessThanOrEqualTo(addCartButton.snp.left).inset(-4)
        }
        
        addCartButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(110)
            make.height.equalTo(36)
        }
        
        parentProductButton.snp.makeConstraints { make in
            make.edges.equalTo(addCartButton)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(addCartButton.snp.bottom).inset(-16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(3)
        }
        
    }
    
    override func configureViews() {
        container.border(with: .olchaLightNeutralDarkGray, width: 1)
        price.style(.bold, 22)
        price.textColor = .olchaTextBlack
        
        shippingType.style(.bold, 14)
        shippingType.textColor = .olchaTextBlack
        shippingTime.numberOfLines = 0
        
        shippingTime.style(.medium, 12)
        shippingTime.textColor = .olchaLightTextColornnnnnn
        
        oldPrice.style(.medium, 16)
        oldPrice.textColor = .olchaLightTextColornnnnnn
        
        link.titleLabel?.style(.semibold, 14)
        link.setTitleColor(.olchaBlue, for: .normal)
        locationContainer.isHidden = true
        locationTitle.textColor = .olchaTextBlack
        locationTitle.style(.bold, 14)
        locationIcon.round(12)
        addCartButton.simpleButton.backColor = .olchaGreen
        addCartButton.simpleButton.titleColor = .olchaWhite
        addCartButton.simpleButton.setTitle("to_basket".localized())
        
        additionalContainer.axis = .vertical
        additionalContainer.spacing = 8
        
        addCartButton.countButton.disableZero = false
        
        
        warrantyContainer.isHidden = true
        warrantyTitle.style(.bold, 14)
        warrantyTitle.textColor = .olchaTextBlack
        warrantyTitle.text = "warranty".localized() + ":"
        
        warrantyValue.style(.medium, 14)
        warrantyValue.textColor = .olchaLightTextColornnnnnn
        
        
        giftTable.delegate = self
        giftTable.dataSource = self
        giftTable.registerClass(forCell: StoreGiftRoom.self)
        giftTable.isScrollEnabled = false
        giftTable.configure()
        
        setupObservers()
        
        parentProductButton.isUserInteractionEnabled = false
    }
    
    private func setupObservers() {
        addCartButton
            .countButton
            .$countClicked
            .sink { [weak self] type in
                guard let self = self,
                      self.storeProduct?.cart_count != self.addCartButton.count else { return }
                
                MetricEvents.shared.cartEvent(self.product, type: type)
                
                CartViewModel.shared.cartChangeCount(productID: self.product?.id,
                                                     storeID: self.storeProduct?.store?.id,
                                                     quantity: self.addCartButton.count,
                                                     type: type)
                
            }.store(in: &bag)
        
        CartViewModel
            .shared
            .cartItemChanged
            .sink { [weak self] cartItem in
                guard let self = self else { return }
                
                
                if cartItem?.product_id == self.product?.id && cartItem?.store_id == self.storeProduct?.store?.id {
                    self.storeProduct?.cart_count = cartItem?.quantity ?? 0
                    self.addCartButton.countButton.count = cartItem?.quantity ?? 0
                }
                
                
            }.store(in: &bag)
     
        link.clicked { [weak self] in
            guard let self = self else { return }
            self.pushStoreObserver?.send(self.storeProduct?.store)
        }
        
        parentProductButton.clicked { [weak self] in
            guard let self = self else { return }
            parentObserver?.send(
                storeProduct?.getProductModel(product)
            )
        }
    }
    
    func setup(with data: StoreProductsData?, product: ProductModel?) {
        self.storeProduct = data
        self.product = product
        
        if Funcs.hasDiscount(store: data) {
            oldPrice.attributedText = Funcs.getOldPrice(store: data).striked
            price.textColor = .olchaAccentColor
        } else {
            price.textColor = .olchaTextBlack
        }
        
        price.text = data?.discount_price?.string.price
        
        shippingType.text = "standard_shipping".localized()
        
        shippingTime.text = data?.store?.getDeliveryInfo()
        
        link.setTitle(data?.store?.getName(), for: .normal)
        
        addCartButton.countButton.maxCount = storeProduct?.quantity ?? Int.max
        addCartButton.countButton.count = storeProduct?.cart_count ?? 0
        checkExtraElements()
    }
    
    func configure(with position: Position) {
        separator.snp.remakeConstraints { make in
            make.top.equalTo(addCartButton.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(3)
        }
        separator.isHidden = false
        
        switch position {
        case .single:
            
            container.round(topCorner: true, bottomCorner: true)
            
            container.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
                make.top.equalToSuperview().inset(16)
            }
            
            hideSeparator()
            break
        case .top:
            container.round(topCorner: true)
            container.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(-2)
                make.top.equalToSuperview().inset(16)
            }
            break
        case .middle:
            container.round(topCorner: false, bottomCorner: false)
            container.snp.updateConstraints { make in
                make.top.bottom.equalToSuperview().inset(-2)
            }
            break
        case .bottom:
            container.round(bottomCorner: true)
            container.snp.updateConstraints { make in
                make.top.equalToSuperview().inset(-2)
                make.bottom.equalToSuperview()
            }
            
            hideSeparator()
            break
        }
    }
    
    
    private func hideSeparator() {
        
        separator.snp.remakeConstraints { make in
            make.top.equalTo(addCartButton.snp.bottom).inset(-16)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
        separator.isHidden = true
    }
    
    
    private func checkExtraElements() {
        
        checkGifts()
        checkWarranty()
        checkDeliveryLocation()
        
    }
    
    private func checkGifts() {
        giftTable.reloadData()
        giftTable.layoutIfNeeded()
    }
    
    private func checkWarranty() {
        warrantyContainer.isHidden = !WarrantyHelper.isWarrantyEnabled(storeProduct)
        warrantyValue.text = WarrantyHelper.getWarrantyTitle(storeProduct)
    }
    
    private func checkDeliveryLocation() {
        locationContainer.isHidden = true
        if let location = storeProduct?.store?.delivery_location {
            locationContainer.isHidden = false
            locationIcon.load(from: location.logo,
                              withIndicator: false,
                              quality: 1,
                              transition: false,
                              imageType: .size(100, 100),
                              contentMode: .scaleAspectFit)
            locationTitle.text = location.name
        }
    }
}
