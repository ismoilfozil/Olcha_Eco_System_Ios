//
//  BillingPaymentItem.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 20/06/23.
//

import UIKit
import OlchaUI
import OlchaUtils

public class BillingPaymentItem: BaseCollectionCell {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }()
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.textAlignment = .center
        label.text = "  "
        return label
    }()
    
    public var isChosen: Bool = false {
        didSet {
            isChosen ? container.border(with: .olchaAccentColor, width: 1) : container.border(with: .clear)
            container.backgroundColor = isChosen ? .olchaAccentColor.withAlphaComponent(0.05) : .lightGrayBackground
        }
    }
    
    public override func prepareForReuse() {
        skeletonViews.forEach { $0.layoutSkeletonIfNeeded() }
        imageView.image = nil
        priceLabel.text = " "
        super.prepareForReuse()
    }
    
    public override func setupViews() {
        container.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(priceLabel)
    }
    
    public override func autolayout() {
        container.snp.remakeConstraints { make in
            make.right.left.equalToSuperview().inset(6)
            make.bottom.top.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(4)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {

        container.backgroundColor = .lightGrayBackground
        container.round()
        makeSkeleton(views: [
            container
        ])
    }
    
    public func setup(with data: BillingCollectionItem) {
        priceLabel.isHidden = false
        imageView.load(from: data.logo,
                       transition: false)
        priceLabel.text = (data.balance?.amount?.string.originalPriceWithoutCurrency ?? "0") + " " + (data.currency ?? Texts.currency)
    }
    
    public func setup(with data: BillingPayment) {
        priceLabel.isHidden = true
        imageView.image = nil
        imageView.load(from: data.logo)
    }
}

