//
//  PartnerLocationRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 19/05/23.
//

import UIKit
import OlchaUI
public class PartnerLocationRoom: BaseView {
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .location
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .olchaPrimaryColor
        label.style(.regular, 14)
        return label
    }()
    
    public override func setupViews() {
        addSubview(logo)
        addSubview(titleLabel)
        addSubview(phoneLabel)
    }
    
    public override func autolayout() {
        logo.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.equalTo(titleLabel.snp.top).inset(8)
            make.left.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.left.equalTo(logo.snp.right).inset(-12)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
            make.bottom.equalToSuperview()
        }
    }
    
    public func setup(title: String?, phone: String?) {
        if let phone = phone, phone != "" {
            phoneLabel.text = phone
        } else {
            phoneLabel.text = " - "
        }
        
        if let title = title, title != "" {
            titleLabel.text = title
        } else {
            titleLabel.text = " - "
        }
        
    }
    
}
