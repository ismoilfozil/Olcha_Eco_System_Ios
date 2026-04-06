//
//  OrderProductRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/10/22.
//

import UIKit
import OlchaUI
class OrderProductRoom: BaseTableCell {

    private let productImage = UIImageView()
    private let productTitle = UILabel()
    private let productPrice = UILabel()
    private let oldProductPrice = UILabel()
    private let amountTitle = UILabel()
    
    let separator = Divide()
    
    var product: ProductModel?
    
    override func setupViews() {
        
        
        container.addSubview(productImage)
        container.addSubview(productTitle)
        container.addSubview(productPrice)
        container.addSubview(oldProductPrice)
        container.addSubview(amountTitle)
        container.addSubview(separator)
    }
    
    override func autolayout() {
        productImage.snp.remakeConstraints { make in
            make.width.height.equalTo(64)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        
        amountTitle.snp.makeConstraints { make in
            make.centerY.equalTo(productTitle.snp.centerY)
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(50)
        }
        
        productTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.right.equalTo(amountTitle.snp.left).inset(-16)
            make.left.equalTo(productImage.snp.right).inset(-8)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        productPrice.snp.makeConstraints { make in
            make.left.equalTo(productTitle.snp.left)
            make.bottom.equalToSuperview().inset(12)
            make.top.equalTo(productTitle.snp.bottom).inset(-12)
        }
        
        oldProductPrice.snp.makeConstraints { make in
            make.left.equalTo(productPrice.snp.right).inset(-8)
            make.bottom.equalTo(productPrice.snp.bottom)
        }
    }
    
    override func configureViews() {
        productTitle.style(.semibold, 14)
        productTitle.numberOfLines = 3
        productTitle.textColor = .olchaTextBlack
        
        productPrice.style(.bold, 16)
        productPrice.textColor = .olchaAccentColor
        
        oldProductPrice.style(.medium, 14)
        oldProductPrice.textColor = .olchaLightTextColornnnnnn
            
        amountTitle.style(.medium, 14)
        amountTitle.textColor = .olchaTextBlack
        amountTitle.textAlignment = .right
    }
    
    func setup(with data: ProductModel?) {
        self.product = data
        productImage.load(from: data?.main_image)

        productTitle.text = data?.getName()
        productPrice.text = data?.price?.price
        amountTitle.text =  "x" + (data?.amount?.string ?? "1")
        withOldPrice(data)
    }
    
    private func withOldPrice(_ product: ProductModel?) {
        if Funcs.hasDiscount(product: product) {
            productPrice.textColor = .olchaAccentColor
            oldProductPrice.attributedText = Funcs.getOldPrice(product: product).striked
        } else {
            productPrice.textColor = .olchaTextBlack
            oldProductPrice.text = ""
        }
    }
    
}
