//
//  BasketProduct.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/07/22.
//

import UIKit
class BasketProduct: UIView {
    private let productImage = UIImageView()
    private let adultChecker = AdultChecker(withTitle: false)
    private let productTitle = UILabel()
    private let productPrice = UILabel()
    private let productOldPrice = UILabel()
    private let rankIcon = UIImageView()
    private let imageSize: CGFloat = 64
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        addSubview(productImage)
        addSubview(adultChecker)
        addSubview(productTitle)
        addSubview(productPrice)
        addSubview(productOldPrice)
    
    }
    
    private func autolayout() {
        productImage.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.height.equalTo(imageSize)
            
        }
        
        adultChecker.snp.makeConstraints { make in
            make.edges.equalTo(productImage)
        }
        
        productTitle.snp.makeConstraints { make in
            make.left.equalTo(productImage.snp.right).inset(-8)
            make.top.right.equalToSuperview()
        }
        
        productPrice.snp.makeConstraints { make in
            make.top.equalTo(productTitle.snp.bottom).inset(-8)
            make.left.equalTo(productTitle)
            make.bottom.equalTo(productImage.snp.bottom)
            make.bottom.equalToSuperview().inset(8)
        }
        
        productOldPrice.snp.makeConstraints { make in
            make.centerY.equalTo(productPrice.snp.centerY)
            make.left.equalTo(productPrice.snp.right).inset(-8)
        }
    }
    
    private func configureViews() {
        productTitle.style(.semibold, 14)
        productTitle.textColor = .olchaTextBlack
        productTitle.numberOfLines = 2
        
        productPrice.style(.bold, 16)
        productPrice.textColor = .olchaTextBlack
        
        
        productOldPrice.style(.medium, 14)
        productOldPrice.textColor = .olchaLightTextColornnnnnn
    }
    
    func setup(with data: ProductModel?) {
        productImage.load(from: data?.main_image,
                          imageType: .equalSize(imageSize))
        productTitle.text = data?.getName()
        
        productPrice.text = data?.total_price?.price

        if Funcs.hasDiscount(product: data) {
            productPrice.textColor = .olchaAccentColor
            productOldPrice.attributedText = Funcs.getOldPrice(product: data).striked
        } else {
            productPrice.textColor = .olchaTextBlack
            productOldPrice.text = ""
        }
        adultChecker.check(data)
    }
}
