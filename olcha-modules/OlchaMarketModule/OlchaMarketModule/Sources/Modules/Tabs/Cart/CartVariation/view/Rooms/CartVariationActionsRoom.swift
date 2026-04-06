//
//  CartVariationActionsRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/11/22.
//

import UIKit
import Combine
import OlchaUI
class CartVariationActionsRoom: BaseTableCell {
    private var bag = Set<AnyCancellable>()

    private let actionButtonsContainer = UIStackView()
    private let addCartButton = CartButton()
    private let goBasketButton = Button()
    private let simpleBuyButton = Button()
    private let separator = UIView()
    
    var fullProduct: FullProductData? {
        didSet {
            actionButtonsContainer.isHidden = (fullProduct == nil)
        }
    }
    var product: ProductModel?
    
    weak var helper: VariationHelper?
    weak var variationError: PassthroughSubject<Bool, Never>?
    weak var goCartObserver: PassthroughSubject<Bool, Never>?
    weak var preOrderObserver: PassthroughSubject<ProductModel?, Never>?
    weak var productHelper: ProductHelper?
    
    override func setupViews() {
        
        container.addSubview(actionButtonsContainer)
        actionButtonsContainer.addArrangedSubview(simpleBuyButton)
        actionButtonsContainer.addArrangedSubview(addCartButton)
        actionButtonsContainer.addArrangedSubview(goBasketButton)
        
        container.addSubview(separator)
        
    }
    
    override func autolayout() {
        
        actionButtonsContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(36)
            make.bottom.equalToSuperview().inset(17)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        
        actionButtonsContainer.axis = .horizontal
        actionButtonsContainer.spacing = 12
        actionButtonsContainer.distribution = .fillEqually
        
        goBasketButton.designAccentButtons("go_basket".localized(), withShadow: false)
        goBasketButton.alpha = 0
        
        
        separator.backgroundColor = .olchaLightNeutralGray
        addCartButton.setup()
        
        simpleBuyButton.titleLabel?.style(.medium, 16)
        simpleBuyButton.round()
        simpleBuyButton.border(with: .olchaTextBlack, width: 2)
        simpleBuyButton.backgroundColor = .olchaWhite
        simpleBuyButton.setTitleColor(.olchaTextBlack, for: .normal)
        simpleBuyButton.setTitle("preOrder".localized(), for: .normal)
        simpleBuyButton.isHidden = true
        
        setupObservers()
    }
    
    private func setupObservers() {
        addCartButton
            .parentPush
            .sink { [weak self] isPushing in
                guard let self = self, isPushing else { return }
                self.variationError?.send(true)
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
                    self.addCartButton.count = cartItem?.quantity ?? 0
                    self.hideGoCartButton()
                }
            }.store(in: &bag)
        
        simpleBuyButton.clicked { [weak self] in
            guard let self = self else { return }
            self.preOrderObserver?.send(self.product)
        }
        
        goBasketButton.clicked { [weak self] in
            guard let self = self else { return }
            self.goCartObserver?.send(true)
        }
        
    }
    
    func setup(with data: ProductModel?, fullProduct: FullProductData?) {
        self.product = data
        fillWithData()
//        guard let fullProduct = fullProduct else { return }
        self.fullProduct = fullProduct
        checkStatus()
    }
    
    private func fillWithData() {
        addCartButton.countButton.count = product?.cart_count ?? 0
        addCartButton.countButton.maxCount = product?.quantity?.int ?? Int.max
    }
    
    private func checkStatus() {
        let isAvailable = Funcs.isAvailableOneClick(fullProduct: fullProduct)

        addCartButton.isHidden = !isAvailable
        simpleBuyButton.isHidden = isAvailable
        hideGoCartButton()
        guard let helper = helper else { return }

        let isSelectedVariation =  Funcs.checkAvailableToBuy(
            selectedOptions: helper.selectedOptions,
            combinationOptions: helper.combinationOptions)
        
        addCartButton.checkButtonStates(isSold: false, isParentProduct: !isSelectedVariation)
    }
    
    private func hideGoCartButton() {
        let isAvailable = Funcs.isAvailableOneClick(fullProduct: fullProduct)
        let isAddedToCart = (product?.cart_count ?? 0) > 0
        goBasketButton.alpha = (isAvailable && isAddedToCart) ? 1 : 0
    }
}
