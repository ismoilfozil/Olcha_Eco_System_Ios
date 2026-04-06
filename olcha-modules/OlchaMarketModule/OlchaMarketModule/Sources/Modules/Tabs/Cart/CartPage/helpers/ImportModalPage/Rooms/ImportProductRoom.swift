//
//  ImportProductRoom.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 03/01/24.
//

import UIKit
import OlchaUI

class ImportProductRoom: BaseTableCell {

    private let flagSize: CGFloat = 18
    
    private let topSeparator = Divide()
    
    private let productImageView: ProductImageView = {
        let imageView = ProductImageView()
        imageView.adultChecker.withTitle = true
        return imageView
    }()
    
    private let dataContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 12)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 2
        return label
    }()
    
    private let flagContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        return stackView
    }()
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.round(flagSize/2)
        return imageView
    }()
    
    private let flagTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    let separator = Divide()

    var topSeparatorHidden: Bool = false {
        didSet {
            topSeparator.isHidden = topSeparatorHidden
        }
    }
    
    override func setupViews() {
        container.addSubview(topSeparator)
        container.addSubview(productImageView)
        container.addSubview(dataContainer)
        dataContainer.addArrangedSubview(titleLabel)
        dataContainer.addArrangedSubview(flagContainer)
        dataContainer.addArrangedSubview(dateLabel)
        container.addSubview(separator)
        
        flagContainer.addArrangedSubview(flagImageView)
        flagContainer.addArrangedSubview(flagTitleLabel)
    }
    
    override func autolayout() {
        topSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        productImageView.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.left.top.equalToSuperview().inset(10)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
        
        dataContainer.snp.makeConstraints { make in
            make.left.equalTo(productImageView.snp.right).inset(-10)
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(10)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        flagContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        flagImageView.snp.makeConstraints { make in
            make.width.height.equalTo(flagSize)
            make.centerY.equalToSuperview()
        }
        
        flagTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    
    func setup(data: ProductModel?) {
        productImageView.settings.load(from: data?.main_image, imageType: .quadratic)
        titleLabel.text = data?.getName()
        flagImageView.load(from: data?.store?.delivery_location?.logo)
        flagTitleLabel.text = data?.store?.delivery_location?.name
        dateLabel.text = data?.store?.getDeliveryInfo()
    }

}
