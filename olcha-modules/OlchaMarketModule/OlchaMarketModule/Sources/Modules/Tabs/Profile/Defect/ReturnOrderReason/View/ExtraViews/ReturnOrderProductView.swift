//
//  ReturnOrderProductView.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 19/10/23.
//

import UIKit
import OlchaUI
import Combine

final class ReturnOrderProductView: BaseView {
    private var bag = Set<AnyCancellable>()
    private let imageSize: CGFloat = 120
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    private let titlesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.style(.medium, 14)
        return label
    }()
    
    let countButton: CartButton = {
        let button = CartButton()
        return button
    }()
    
    private let divide = Divide()
    
    override func setupViews() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(productImageView)
        containerStackView.addArrangedSubview(titlesStackView)
        
        titlesStackView.addArrangedSubview(titleLabel)
        titlesStackView.addArrangedSubview(priceLabel)
        titlesStackView.addArrangedSubview(countButton)
        
        addSubview(divide)
    }
    
    override func autolayout() {
        containerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        divide.snp.makeConstraints { make in
            make.top.equalTo(containerStackView.snp.bottom).inset(-16)
            make.left.right.bottom.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }

        countButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.greaterThanOrEqualTo(100)
            make.height.equalTo(36)
        }
        
        productImageView.snp.makeConstraints { make in
            make.width.height.equalTo(imageSize)
        }
    }
    
    override func configureViews() {
        countButton.countButton.disableZero = true
    }
    
    func setup(with data: ProductModel?) {
        productImageView.load(from: data?.main_image, imageType: .equalSize(imageSize))
        titleLabel.text = data?.getName()
        priceLabel.text = data?.price?.price
        countButton.countButton.maxCount = data?.amount ?? 1
    }
}
