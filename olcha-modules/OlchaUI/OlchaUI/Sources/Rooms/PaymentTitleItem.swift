//
//  PaymentTypeItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/10/22.
//

import UIKit

public class PaymentTitleItem: BaseCollectionCell {
    
    private let radioIcon: IconButton = {
        let button = IconButton()
        button.isUserInteractionEnabled = false
        button.setIcon(.round_unselected_check)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 2
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    public let rightButton: IconButton = {
        let button = IconButton()
        button.round()
        button.border()
        button.setIcon(.plus, edgeSize: 4, isIgnoringEdge: false)
        return button
    }()
    
    public var isChosen: Bool = false {
        didSet {
            container.border(with: isChosen ? .olchaAccentColor : .olchaLightNeutralGray,
                             width: 2)
            radioIcon.setIcon(isChosen ? .round_selected_check : .round_unselected_check)
        }
    }
    public var rightButtonEnabled: Bool = false {
        didSet {
            rightButton.isHidden = !rightButtonEnabled
            rightButton.settings.isEnabled = rightButtonEnabled
        }
    }
    
    public override func setupViews() {
        container.addSubview(radioIcon)
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)
        container.addSubview(rightButton)
    }
    
    public override func autolayout() {
        verticalEdge = 4
        
        radioIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(19)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(radioIcon.snp.centerY)
            make.left.equalTo(radioIcon.snp.right).inset(-12)
            make.right.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.top.equalTo(titleLabel.snp.bottom).inset(-12)
            make.bottom.equalToSuperview().inset(16)
        }
        
        rightButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(16)
            make.width.height.equalTo(30)
        }
    }
    
    public override func configureViews() {
        
        container.round()
        container.border(width: 2)
        
        rightButtonEnabled = false
        
        makeSkeleton(views: [
            container,
            radioIcon,
            titleLabel,
            subtitleLabel,
            rightButton
        ])
    }
 
    
    public func setup(title: String, subtitle: String) {
        
        titleLabel.text = title

        subtitleLabel.text = subtitle
    }
}
