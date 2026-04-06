//
//  PaymentIconItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/10/22.
//

import UIKit
import OlchaUtils

public class PaymentIconItem: BaseCollectionCell {

    private let dataStack = UIStackView()
    
    private let radioIcon = IconButton()
    
    private let imageView = UIImageView()
    
    private let amountTitle = UILabel()
    
    private let width: CGFloat = 100
    private let height: CGFloat = 30
    
    public var isChosen: Bool = false {
        didSet {
            container.border(with: isChosen ? .olchaAccentColor : .olchaLightNeutralGray,
                             width: 2)
            radioIcon.setIcon(isChosen ? .round_selected_check : .round_unselected_check)
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    public override func setupViews() {
        container.addSubview(radioIcon)
        container.addSubview(dataStack)
        dataStack.addArrangedSubview(imageView)
        dataStack.addArrangedSubview(amountTitle)
    }
    
    public override func autolayout() {
        verticalEdge = 4
        
        radioIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(100)
            make.height.equalTo(30)
        }
        
        dataStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(radioIcon.snp.right).inset(-12)
            make.right.equalToSuperview().inset(20)
        }
    }
    
    public override func configureViews() {
        radioIcon.isUserInteractionEnabled = false
        dataStack.axis = .vertical
        dataStack.spacing = 4
        dataStack.alignment = .leading
        dataStack.distribution = .fill
        
        
        container.round()
        container.border(width: 2)
        
        imageView.contentMode = .scaleAspectFit
        
        radioIcon.setIcon(.round_unselected_check)
        
        amountTitle.style(.medium, 14)
        amountTitle.textColor = .olchaLightTextColornnnnnn
        amountTitle.numberOfLines = 1
        amountTitle.isHidden = true
        
    }
    
    public func setup(with data: Payments?) {
        if let img = data?.staticImage {
            imageView.image = UIImage(named: img)
        } else {
            imageView.load(from: data?.logo,
                           transition: false,
                           imageType: .size(width, height),
                           contentMode: .scaleAspectFit)
        }
        amountTitle.isHidden = (data?.balance_alias ?? "") == ""
    }
    
    public func setup(amount: String?) {
        amountTitle.text = amount?.originalPrice
    }
}
