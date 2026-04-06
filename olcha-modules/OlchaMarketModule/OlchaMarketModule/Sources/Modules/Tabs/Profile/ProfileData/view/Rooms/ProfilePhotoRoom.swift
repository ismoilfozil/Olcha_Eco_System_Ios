//
//  ProfilePhotoRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 22/09/22.
//

import UIKit
import OlchaUI
class ProfilePhotoRoom: BaseTableCell {
    
    private let imageButton = IconButton()
    
    private let titleLabel = UILabel()
    
    private let valueLabel = UILabel()
    
    private let verifiedIcon = UIImageView()
    
    private let rightIcon = UIImageView()
    
    private let separator = Divide()

    override func setupViews() {
        container.addSubview(imageButton)
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        container.addSubview(verifiedIcon)
        container.addSubview(rightIcon)
        container.addSubview(separator)
    }
    
    override func autolayout() {
        imageButton.snp.makeConstraints { make in
            make.width.height.equalTo(56)
            make.top.left.equalToSuperview().inset(16)
            make.bottom.equalTo(separator.snp.top).inset(-16)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageButton.snp.right).inset(-12)
            make.top.equalToSuperview().inset(20)
            make.right.equalTo(rightIcon.snp.left).inset(-8)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.left.equalTo(imageButton.snp.right).inset(-12)
            make.bottom.equalTo(separator.snp.top).inset(-20)
            
        }
        
        verifiedIcon.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerY.equalTo(valueLabel.snp.centerY)
            make.left.equalTo(valueLabel.snp.right).inset(-4)
            make.right.lessThanOrEqualTo(rightIcon.snp.left).inset(-8)
        }
        
        rightIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        imageButton.round(28)
        imageButton.backgroundColor = .olchaLightNeutralGray
        imageButton.setIcon(.camera_simple?.withColor(.olchaLightTextColornnnnnn ?? .gray), edgeSize: 16, isIgnoringEdge: false)
        
        titleLabel.style(.regular, 14)
        titleLabel.textColor = .olchaLightTextColornnnnnn
        
        valueLabel.style(.semibold, 16)
        valueLabel.textColor = .olchaTextBlack
        
        verifiedIcon.image = .verified
        rightIcon.image = .rightIcon?.withColor(.olchaLightTextColornnnnnn ?? .gray)
        
        titleLabel.text = "name_lastname".localized()
        valueLabel.text =  " "
        
        verifiedIcon.isHidden = true
    }
    
    func setup(name: String, isVerified: Bool) {
        valueLabel.text = name
        verifiedIcon.isHidden = !isVerified
    }
    
}
 
