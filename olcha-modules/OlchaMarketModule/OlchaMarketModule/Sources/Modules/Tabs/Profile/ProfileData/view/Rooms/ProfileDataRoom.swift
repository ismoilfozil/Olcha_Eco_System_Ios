//
//  ProfileDataRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 22/09/22.
//

import UIKit
import OlchaUI
class ProfileDataRoom: BaseTableCell {

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let separator = Divide()
    private let rightIcon = UIImageView()
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        container.addSubview(separator)
        container.addSubview(rightIcon)
    }
    
    override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
            make.height.equalTo(20)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
            make.bottom.equalTo(separator.snp.top).inset(-8)
            make.height.equalTo(24)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        rightIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(titleLabel.snp.right).inset(-8)
            make.left.equalTo(valueLabel.snp.right).inset(-8)
        }
    }
    
    override func configureViews() {
        titleLabel.style(.regular, 14)
        titleLabel.textColor = .olchaLightTextColornnnnnn
        
        valueLabel.style(.semibold, 16)
        valueLabel.textColor = .olchaTextBlack
        
        rightIcon.image = .rightIcon?.withColor(.olchaLightTextColornnnnnn ?? .gray)
    }
    
    func setup(title: String?, value: String?, withRight: Bool) {
        titleLabel.text = title ?? ""
        valueLabel.text = value ?? ""
        rightIcon.isHidden = !withRight
    }
    
}
