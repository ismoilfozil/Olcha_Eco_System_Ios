//
//  CatalogSelectRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 09/08/22.
//

import UIKit
import OlchaUI
class CatalogSelectRoom: BaseCollectionCell {
    
    private let leftIcon = UIImageView()
    private let titleLabel = UILabel()
    private let rightIcon = UIImageView()
    
    override func setupViews() {
        container.addSubview(leftIcon)
        container.addSubview(titleLabel)
        container.addSubview(rightIcon)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 16
        
        leftIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(leftIcon.snp.right).inset(-8)
            make.right.equalTo(rightIcon.snp.left).inset(-8)
            make.top.bottom.equalToSuperview()
        }
        
        rightIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureViews() {
        container.round(8)
        container.backgroundColor = .olchaLightNeutralGray
        
        leftIcon.image = .category
        titleLabel.style(.bold, 16)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.text = "categories".localized()
        
        rightIcon.image = .rightIcon?.withColor(.olchaLightTextColornnnnnn ?? .lightText)
    }
    
}
