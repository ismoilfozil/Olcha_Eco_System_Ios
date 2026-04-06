//
//  ProfileDataMainRoom.swift
//  OlchaProfileModule
//
//  Created by Elbek Khasanov on 19/09/23.
//

import UIKit
import OlchaUI

class ProfileDataUserRoom: BaseTableCell {
    
    private lazy var mainIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .user
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    private lazy var rightIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .rightIcon
        return imageView
    }()
    
    override func setupViews() {
        container.addSubview(mainIcon)
        container.addSubview(nameLabel)
        container.addSubview(subtitleLabel)
        container.addSubview(rightIcon)
    }
    
    override func autolayout() {
        mainIcon.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(56)
            make.top.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        
    }
    
}
