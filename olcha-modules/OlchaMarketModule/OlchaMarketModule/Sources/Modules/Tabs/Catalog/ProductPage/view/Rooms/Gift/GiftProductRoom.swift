//
//  GiftProductRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 14/02/23.
//

import UIKit
import OlchaUI
class GiftProductRoom: BaseTableCell {
    private let productImage = UIImageView()
    private let adultChecker = AdultChecker(withTitle: false)
    private let productTitle = UITextView()
 
    
    override func setupViews() {
        container.addSubview(productImage)
        container.addSubview(adultChecker)
        container.addSubview(productTitle)
    }
    
    override func autolayout() {
        self.productImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(72)
        }
        
        self.adultChecker.snp.makeConstraints { make in
            make.edges.equalTo(self.productImage)
        }
        
        self.productTitle.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalTo(self.productImage.snp.right).inset(-8)
            make.right.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        productTitle.font = .style(.medium, 16)
        productTitle.textColor = .olchaTextBlack
        productTitle.textContainer.lineBreakMode = .byCharWrapping
        productTitle.disable()
    }
    
    func setup(with data: ProductModel?) {
        productImage.load(from: data?.main_image)
        productTitle.text = data?.getName()
        adultChecker.check(data)
    }
}
class GiftProductRoomView: BaseTableCellView {
    private let productImage = UIImageView()
    private let adultChecker = AdultChecker(withTitle: false)
    private let productTitle = UITextView()
 
    
    override func setupViews() {
        container.addSubview(productImage)
        container.addSubview(adultChecker)
        container.addSubview(productTitle)
    }
    
    override func autolayout() {
        self.productImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(72)
        }
        
        self.adultChecker.snp.makeConstraints { make in
            make.edges.equalTo(self.productImage)
        }
        
        self.productTitle.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalTo(self.productImage.snp.right).inset(-8)
            make.right.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        productTitle.font = .style(.medium, 16)
        productTitle.textColor = .olchaTextBlack
        productTitle.textContainer.lineBreakMode = .byCharWrapping
        productTitle.disable()
    }
    
    func setup(with data: ProductModel?) {
        productImage.load(from: data?.main_image)
        productTitle.text = data?.getName()
        adultChecker.check(data)
    }
}
