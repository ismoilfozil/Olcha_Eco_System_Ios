//
//  ReviewProductRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/03/23.
//

import UIKit
import OlchaUI
class ReviewProductRoom: BaseTableCell {


    private let productImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    
    private let imageSize: CGFloat = 80
    
    
    
    override func setupViews() {
        container.addSubview(productImageView)
        container.addSubview(titleLabel)
        container.addSubview(priceLabel)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        
        productImageView.snp.makeConstraints { make in
            make.width.height.equalTo(imageSize)
            make.top.left.bottom.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(productImageView.snp.right).inset(-16)
            make.top.right.equalToSuperview().inset(16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.top.greaterThanOrEqualTo(titleLabel.snp.bottom)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        container.round()
        container.border()
        
        titleLabel.style(.semibold, 14)
        titleLabel.numberOfLines = 3
        titleLabel.textColor = .olchaTextBlack
        titleLabel.text = " "
        
        priceLabel.style(.bold, 16)
        priceLabel.textColor = .olchaTextBlack
    }
    
    func setup(with data: ProductModel?) {
        titleLabel.text = data?.getName()
        priceLabel.text = data?.total_price?.price
        productImageView.load(from: data?.main_image,
                              imageType: .equalSize(imageSize))
    }
}
