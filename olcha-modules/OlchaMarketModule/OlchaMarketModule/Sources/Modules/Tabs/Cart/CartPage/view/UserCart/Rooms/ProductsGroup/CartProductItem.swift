//
//  CartProductItem.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 31/01/24.
//

import UIKit
import OlchaUI

class CartProductItem: BaseCollectionCell {
    private let imageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaLightGray
        view.round(8)
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let countLabel: Label = {
        let label = Label()
        label.settings.style(.medium, 12)
        label.settings.textColor = .olchaTextBlack
        label.settings.textAlignment = .center
        label.backgroundColor = .hex("#707070").withAlphaComponent(0.2)
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func setupViews() {
        container.addSubview(imageContainer)
        imageContainer.addSubview(imageView)
        container.addSubview(countLabel)
    }
    
    override func autolayout() {
        let countLabelSize: CGFloat = 18
        let countLabelMargin: CGFloat = 4
        countLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(countLabelMargin)
            
            make.height.equalTo(countLabelSize)
            make.width.greaterThanOrEqualTo(countLabelSize)
        }
        
        countLabel.round(countLabelSize/2)
        
        imageContainer.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(countLabelMargin + countLabelSize/2)
            make.right.equalToSuperview().inset(countLabelMargin + countLabelSize/2)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
    }
    
    override func configureViews() {
        makeSkeleton(views: [
            imageContainer,
            countLabel
        ])
    }
    
    public func setup(product: ProductModel?) {
        imageView.load(from: product?.main_image, imageType: .quadratic)
        countLabel.text = "x" + (product?.cart_count?.string ?? "0")
    }
    
    
}
