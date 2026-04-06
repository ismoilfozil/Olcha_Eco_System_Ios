//
//  ReturnOrderProductRoom.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 18/10/23.
//

import UIKit
import OlchaUI

class ReturnOrderProductRoom: BaseTableCell {
    
    private let imageSize: CGFloat = 120
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fill
        stackView.alignment = .firstBaseline
        return stackView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titlesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 12)
        label.numberOfLines = 0
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let skuContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let skuTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 10)
        label.textColor = .olchaDarkNeutralGray
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let skuValueLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 10)
        label.textColor = .olchaTextBlack
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let divide = Divide()
    
    let cancelButton: IButton = {
        let button = IButton()
        button.titleLabel?.style(.medium, 14)
        button.round()
        button.backgroundColor = .olchaLightNeutralGray
        button.setTitleColor(.olchaTextBlack, for: .normal)
        return button
    }()
    
    override func setupViews() {
        
        container.addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(productImageView)
        containerStackView.addArrangedSubview(titlesStackView)
        
        titlesStackView.addArrangedSubview(titleLabel)
        titlesStackView.addArrangedSubview(skuContainer)
        skuContainer.addSubview(skuTitleLabel)
        skuContainer.addSubview(skuValueLabel)
        titlesStackView.addArrangedSubview(priceLabel)
        titlesStackView.addArrangedSubview(countLabel)
        
        container.addSubview(divide)
        container.addSubview(cancelButton)
    }
    
    override func autolayout() {
        containerStackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        divide.snp.makeConstraints { make in
            make.top.equalTo(containerStackView.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(cancelButton.snp.top).inset(-16)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.bottom.left.equalToSuperview().inset(16)
            make.width.equalTo(120)
            make.height.equalTo(44)
        }
        
        productImageView.snp.makeConstraints { make in
            make.width.height.equalTo(imageSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        skuContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        skuTitleLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        
        skuValueLabel.snp.makeConstraints { make in
            make.left.equalTo(skuTitleLabel.snp.right).inset(-2)
            make.top.bottom.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        verticalEdge = 8
        horizontalEdge = 16
    }
    
    override func configureViews() {
        container.round()
        container.border()
    }
    
    func setup(with data: ProductModel?) {
        productImageView.load(from: data?.main_image)
        productImageView.load(from: data?.main_image, imageType: .equalSize(imageSize))
        titleLabel.text = data?.getName()
        priceLabel.text = data?.price?.price
        countLabel.text = "x \(data?.amount ?? 1)"
        skuTitleLabel.text = "articul".localized() + ": "
        skuValueLabel.text = data?.id?.string
        cancelButton.setTitle("cancel".localized(), for: .normal)
    }
}
