//
//  ProfileMenuRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/09/22.
//

import UIKit
public class ProfileMenuRoom: BaseTableCell {
    
    public let menuIcon = UIImageView()
    
    public let rightIcon = UIImageView()
    
    public let menuTitle = UILabel()
    
    public let rightBadgeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaAccentColor
        view.round(12)
        view.isHidden = true
        return view
    }()
    
    public let rightBadgeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaWhite
        label.style(.regular, 12)
        label.textAlignment = .center
        return label
    }()
    
    public override func setupViews() {
        container.addSubview(menuIcon)
        container.addSubview(menuTitle)
        container.addSubview(rightIcon)
        container.addSubview(rightBadgeContainer)
        rightBadgeContainer.addSubview(rightBadgeTitleLabel)
    }
    
    public override func autolayout() {
        horizontalEdge = 16
        
        menuIcon.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        menuTitle.snp.makeConstraints { make in
            make.left.equalTo(menuIcon.snp.right).inset(-12)
            make.right.equalTo(rightBadgeContainer.snp.left).inset(-12)
            make.top.bottom.equalToSuperview().inset(16)
        }
        
        rightIcon.snp.makeConstraints { make in
            make.centerY.right.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        rightBadgeContainer.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(rightIcon.snp.left).inset(-4)
            make.width.height.equalTo(24)
        }
        
        rightBadgeTitleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        menuTitle.style(.medium, 16)
        menuTitle.numberOfLines = 0
        menuTitle.textColor = .olchaTextBlack
        
        rightIcon.image = .rightIcon?.withColor(.olchaLightTextColornnnnnn ?? .lightGray)
    }
    
    public func setup(image: UIImage?, title: String, accentColor: UIColor? = .olchaTextBlack) {
        menuIcon.image = image
        menuTitle.text = title
        menuTitle.textColor = accentColor
    }
    
    public func setup(badge: Int = 0) {
        rightBadgeTitleLabel.text = badge.string
        rightBadgeContainer.isHidden = !(badge > 0)
    }
}
