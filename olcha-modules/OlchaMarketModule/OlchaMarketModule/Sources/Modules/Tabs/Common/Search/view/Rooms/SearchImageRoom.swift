//
//  SearchImageRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 31/10/22.
//

import UIKit
import OlchaUI

class SearchImageRoom: BaseTableCell {
    
    private let leftIcon = UIImageView()
    private let titlesStack = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    let rightIcon = IconButton()
    private let separator = Divide()
    
    override func setupViews() {
        container.addSubview(leftIcon)
        container.addSubview(titlesStack)
        titlesStack.addArrangedSubview(titleLabel)
        titlesStack.addArrangedSubview(subtitleLabel)
        
        container.addSubview(rightIcon)
        container.addSubview(separator)
    }
    
    override func autolayout() {
        leftIcon.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.left.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        titlesStack.snp.makeConstraints { make in
            make.left.equalTo(leftIcon.snp.right).inset(-8)
            make.right.equalTo(rightIcon.snp.left).inset(-8)
            make.centerY.equalToSuperview()
        }
        
        
        rightIcon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        titlesStack.axis = .vertical
        titlesStack.spacing = 0
        subtitleLabel.isHidden = true
        
        titleLabel.style(.medium, 14)
        titleLabel.textColor = .olchaTextBlack
        
        subtitleLabel.style(.regular, 12)
        subtitleLabel.textColor = .olchaLightTextColornnnnnn
        
        rightIcon.setIcon(.rightIcon?.withColor(.olchaLightTextColornnnnnn ?? .gray))
        
    }
    
    func setup(product: ProductModel?) {
        titleLabel.text = product?.getName() ?? ""
        subtitleLabel.text = product?.total_price?.price
        leftIcon.load(from: product?.main_image)
    }
    
}
