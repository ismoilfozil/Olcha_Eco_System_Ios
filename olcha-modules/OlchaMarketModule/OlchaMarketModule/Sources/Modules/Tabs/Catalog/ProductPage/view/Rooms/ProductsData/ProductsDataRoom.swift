//
//  ProductsDataRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/07/22.
//

import UIKit
import OlchaUI
import Combine
class ProductsDataRoom: BaseTableCell {
    private let containerStack = UIStackView()
    private let brandTitle = Button()
    private let productNameTitle = UILabel()
    private let priceContainer = UIView()
    private let priceTitle = UILabel()
    private let oldPriceTitle = UILabel()
    private let permonthPriceContainer = UIView()
    private let permonthPrice = UILabel()
    
    private let cashbackContainer = CashbackView()
    
    weak var pushBrandObserver: PassthroughSubject<Manufacturer?, Never>?
    
    var product: ProductModel?
    
    override func setupViews() {
        container.addSubview(containerStack)
        containerStack.addArrangedSubview(brandTitle)
        containerStack.addArrangedSubview(productNameTitle)
        containerStack.addArrangedSubview(priceContainer)
        priceContainer.addSubview(priceTitle)
        priceContainer.addSubview(oldPriceTitle)
        
        containerStack.addArrangedSubview(permonthPriceContainer)
        permonthPriceContainer.addSubview(permonthPrice)
        containerStack.addArrangedSubview(cashbackContainer)
        
        
    }
    
    override func autolayout() {
        containerStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        priceTitle.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(8)
        }
        
        oldPriceTitle.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(self.priceTitle.snp.centerY)
            make.left.equalTo(self.priceTitle.snp.right).inset(-12)
        }
        
        permonthPriceContainer.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        permonthPrice.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(8)
        }
        
        
    }
    
    override func configureViews() {
        containerStack.axis = .vertical
        containerStack.spacing = 4
        containerStack.alignment = .leading
        
        brandTitle.setTitleColor(.olchaBlue, for: .normal)
        brandTitle.titleLabel?.style(.semibold, 14)
        
        productNameTitle.textColor = .olchaTextBlack
        productNameTitle.style(.semibold, 24)
        productNameTitle.numberOfLines = 0
        
        priceTitle.textColor = .olchaAccentColor
        priceTitle.style(.bold, 22)
        
        oldPriceTitle.textColor = .olchaLightTextColornnnnnn
        oldPriceTitle.style(.medium, 16)
        
        permonthPrice.textColor = .olchaTextBlack
        permonthPriceContainer.round(6)
        permonthPriceContainer.backgroundColor = .olchaYellow
        permonthPrice.style(.semibold, 12)
        permonthPrice.textAlignment = .center
        
        brandTitle.clicked { [weak self] in
            guard let self = self else { return }
            self.pushBrandObserver?.send(self.product?.manufacturer)
        }
    }
    
    
    func setup(with data: ProductModel?) {
        self.product = data
        brandTitle.setTitle(data?.manufacturer?.getName(), for: .normal)
        
        productNameTitle.text = data?.getName()
        
        priceTitle.text = data?.total_price?.price
        if Funcs.hasDiscount(product: data) {
            oldPriceTitle.attributedText = Funcs.getOldPrice(product: data).striked
        } else {
            oldPriceTitle.text = ""
        }
        
        if let repayment = data?.monthly_repayment,
           let month_period = data?.plan?.max_period {
            permonthPriceContainer.isHidden = false
            permonthPrice.text = repayment.string.price + " x " + month_period.month
        } else {
            permonthPriceContainer.isHidden = true
        }
        let cashback = data?.cashback_percent
        cashbackContainer.setup(percent: cashback)
        
    }
}

class ProductsDataRoomView: BaseTableCellView {
    private let containerStack = UIStackView()
    private let brandTitle = IButton()
    private let productNameTitle = UILabel()
    private let priceContainer = UIView()
    private let priceTitle = UILabel()
    private let oldPriceTitle = UILabel()
    private let permonthPriceContainer = UIView()
    private let permonthPrice = UILabel()
    
    private let cashbackContainer = CashbackView()
    
    weak var pushBrandObserver: PassthroughSubject<Manufacturer?, Never>?
    
    var product: ProductModel?
    
    override func setupViews() {
        container.addSubview(containerStack)
        containerStack.addArrangedSubview(brandTitle)
        containerStack.addArrangedSubview(productNameTitle)
        containerStack.addArrangedSubview(priceContainer)
        priceContainer.addSubview(priceTitle)
        priceContainer.addSubview(oldPriceTitle)
        
        containerStack.addArrangedSubview(permonthPriceContainer)
        permonthPriceContainer.addSubview(permonthPrice)
        containerStack.addArrangedSubview(cashbackContainer)
        
        
    }
    
    override func autolayout() {
        containerStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        priceTitle.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(8)
        }
        
        oldPriceTitle.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(self.priceTitle.snp.centerY)
            make.left.equalTo(self.priceTitle.snp.right).inset(-12)
        }
        
        permonthPriceContainer.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        permonthPrice.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(8)
        }
        
        
    }
    
    override func configureViews() {
        containerStack.axis = .vertical
        containerStack.spacing = 4
        containerStack.alignment = .leading
        
        brandTitle.setTitleColor(.olchaBlue, for: .normal)
        brandTitle.titleLabel?.style(.semibold, 14)
        
        productNameTitle.textColor = .olchaTextBlack
        productNameTitle.style(.semibold, 24)
        productNameTitle.numberOfLines = 0
        
        priceTitle.textColor = .olchaAccentColor
        priceTitle.style(.bold, 22)
        
        oldPriceTitle.textColor = .olchaLightTextColornnnnnn
        oldPriceTitle.style(.medium, 16)
        
        permonthPrice.textColor = .olchaTextBlack
        permonthPriceContainer.round(6)
        permonthPriceContainer.backgroundColor = .olchaYellow
        permonthPrice.style(.semibold, 12)
        permonthPrice.textAlignment = .center
        
        brandTitle.clicked { [weak self] in
            guard let self = self else { return }
            self.pushBrandObserver?.send(self.product?.manufacturer)
        }
    }
    
    
    func setup(with data: ProductModel?) {
        self.product = data
        brandTitle.setTitle(data?.manufacturer?.getName(), for: .normal)
        
        productNameTitle.text = data?.getName()
        
        priceTitle.text = data?.total_price?.price
        if Funcs.hasDiscount(product: data) {
            oldPriceTitle.attributedText = Funcs.getOldPrice(product: data).striked
        } else {
            oldPriceTitle.text = ""
        }
        
        if let repayment = data?.monthly_repayment,
           let month_period = data?.plan?.max_period {
            permonthPriceContainer.isHidden = false
            permonthPrice.text = repayment.string.price + " x " + month_period.month
        } else {
            permonthPriceContainer.isHidden = true
        }
        let cashback = data?.cashback_percent
        cashbackContainer.setup(percent: cashback)
        
    }
}

