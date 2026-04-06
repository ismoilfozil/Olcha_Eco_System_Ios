//
//  ProductActionsRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/07/22.
//

import UIKit
import Combine
import OlchaUI

class ProductActionsRoom: BaseTableCell {
    private var bag = Set<AnyCancellable>()
    
    private let containerStack = UIStackView()
    
    let basketButton = Button()
    let creditButton = Button()
    let simpleBuyButton = Button()
    
    var fullProduct: FullProductData?
    var product: ProductModel?
    override func setupViews() {
        container.addSubview(containerStack)
        containerStack.addArrangedSubview(basketButton)
        containerStack.addArrangedSubview(creditButton)
        containerStack.addArrangedSubview(simpleBuyButton)
    }
    
    override func autolayout() {
        containerStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        basketButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        creditButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        simpleBuyButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    override func configureViews() {
        containerStack.axis = .vertical
        containerStack.spacing = 8
        
        basketButton.titleLabel?.style(.medium, 16)
        creditButton.titleLabel?.style(.medium, 16)
        simpleBuyButton.titleLabel?.style(.medium, 16)
        
        basketButton.round()
        creditButton.round()
        simpleBuyButton.round()
        
        basketButton.titleEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
        basketButton.border(with: .olchaGreen, width: 2)
        
        creditButton.backgroundColor = .olchaAccentColor
        creditButton.setTitleColor(.olchaWhite, for: .normal)
        creditButton.setTitle("installment_buy".localized(), for: .normal)
        
        simpleBuyButton.border(with: .olchaTextBlack, width: 2)
        simpleBuyButton.backgroundColor = .olchaWhite
        simpleBuyButton.setTitleColor(.olchaTextBlack, for: .normal)
        simpleBuyButton.setTitle("buy_one_click".localized(), for: .normal)
        
        CartViewModel
            .shared
            .cartItemChanged
            .sink { [weak self] cartItem in
                guard let self = self else { return }
                if cartItem?.product_id == self.product?.id && cartItem?.store_id == self.product?.getStoreID() {
                    self.product?.cart_count = cartItem?.quantity ?? 0
                    if (cartItem?.quantity ?? 0) > 0 {
                        self.activeCartButton()
                    } else {
                        self.deactiveCartButton()
                    }
                }
            }.store(in: &bag)
    }
    
    private func checkStatus() {
        basketButton.isHidden = !Funcs.isAvailableBasket(fullProduct: fullProduct)
        creditButton.isHidden = !Funcs.isAvailableCredit(fullProduct: fullProduct)
        if Funcs.isAvailableOneClick(fullProduct: fullProduct) {
            simpleBuyButton.setTitle("buy_one_click".localized(), for: .normal)
        } else {
            simpleBuyButton.setTitle("preOrder".localized(), for: .normal)
        }
        
        if (product?.cart_count ?? 0) > 0 {
            activeCartButton()
        } else {
            deactiveCartButton()
        }
    }
    
    func setup(with data: FullProductData?, product: ProductModel?) {
        self.fullProduct = data
        self.product = product
        checkStatus()
    }
    
    private func activeCartButton() {
        
        basketButton.backgroundColor = .olchaWhite
        basketButton.setTitleColor(.olchaGreen, for: .normal)
        basketButton.setTitle("go_basket".localized(), for: .normal)
        basketButton.setImage(.bag?.resizedImage(24)?.withColor(.olchaGreen ?? .green), for: .normal)
        
    }
    
    private func deactiveCartButton() {
        
        basketButton.backgroundColor = .olchaGreen
        basketButton.setTitleColor(.olchaWhite, for: .normal)
        basketButton.setTitle("to_basket".localized(), for: .normal)
        basketButton.setImage(.bag?.resizedImage(24), for: .normal)
        
    }
}
class ProductActionsRoomView: BaseTableCellView {
    private var bag = Set<AnyCancellable>()
    
    private let containerStack = UIStackView()
    
    let basketButton = Button()
    let creditButton = Button()
    let simpleBuyButton = Button()
    
    var fullProduct: FullProductData?
    var product: ProductModel?
    override func setupViews() {
        container.addSubview(containerStack)
        containerStack.addArrangedSubview(basketButton)
        containerStack.addArrangedSubview(creditButton)
        containerStack.addArrangedSubview(simpleBuyButton)
    }
    
    override func autolayout() {
        containerStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        basketButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        creditButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        simpleBuyButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    override func configureViews() {
        containerStack.axis = .vertical
        containerStack.spacing = 8
        
        basketButton.titleLabel?.style(.medium, 16)
        creditButton.titleLabel?.style(.medium, 16)
        simpleBuyButton.titleLabel?.style(.medium, 16)
        
        basketButton.round()
        creditButton.round()
        simpleBuyButton.round()
        
        basketButton.titleEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
        basketButton.border(with: .olchaGreen, width: 2)
        
        creditButton.backgroundColor = .olchaAccentColor
        creditButton.setTitleColor(.olchaWhite, for: .normal)
        creditButton.setTitle("installment_buy".localized(), for: .normal)
        
        simpleBuyButton.border(with: .olchaTextBlack, width: 2)
        simpleBuyButton.backgroundColor = .olchaWhite
        simpleBuyButton.setTitleColor(.olchaTextBlack, for: .normal)
        simpleBuyButton.setTitle("buy_one_click".localized(), for: .normal)
        
        CartViewModel
            .shared
            .cartItemChanged
            .sink { [weak self] cartItem in
                guard let self = self else { return }
                if cartItem?.product_id == self.product?.id && cartItem?.store_id == self.product?.getStoreID() {
                    self.product?.cart_count = cartItem?.quantity ?? 0
                    if (cartItem?.quantity ?? 0) > 0 {
                        self.activeCartButton()
                    } else {
                        self.deactiveCartButton()
                    }
                }
            }.store(in: &bag)
    }
    
    private func checkStatus() {
        basketButton.isHidden = !Funcs.isAvailableBasket(fullProduct: fullProduct)
        creditButton.isHidden = !Funcs.isAvailableCredit(fullProduct: fullProduct)
        if Funcs.isAvailableOneClick(fullProduct: fullProduct) {
            simpleBuyButton.setTitle("buy_one_click".localized(), for: .normal)
        } else {
            simpleBuyButton.setTitle("preOrder".localized(), for: .normal)
        }
        
        if (product?.cart_count ?? 0) > 0 {
            activeCartButton()
        } else {
            deactiveCartButton()
        }
    }
    
    func setup(with data: FullProductData?, product: ProductModel?) {
        self.fullProduct = data
        self.product = product
        checkStatus()
    }
    
    private func activeCartButton() {
        
        basketButton.backgroundColor = .olchaWhite
        basketButton.setTitleColor(.olchaGreen, for: .normal)
        basketButton.setTitle("go_basket".localized(), for: .normal)
        basketButton.setImage(.bag?.resizedImage(24)?.withColor(.olchaGreen ?? .green), for: .normal)
        
    }
    
    private func deactiveCartButton() {
        
        basketButton.backgroundColor = .olchaGreen
        basketButton.setTitleColor(.olchaWhite, for: .normal)
        basketButton.setTitle("to_basket".localized(), for: .normal)
        basketButton.setImage(.bag?.resizedImage(24), for: .normal)
        
    }
}
