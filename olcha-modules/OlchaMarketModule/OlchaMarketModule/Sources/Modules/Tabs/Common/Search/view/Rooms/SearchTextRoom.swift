//
//  SearchTextRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/10/22.
//

import UIKit
import OlchaUI
class SearchTextRoom: BaseTableCell {

    enum RoomType {
        case history
        case title
    }
    
    private let leftIcon = UIImageView()
    private let titlesStack = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    let rightIcon = IconButton()
    private let separator = Divide()
    
    var type: RoomType = .title {
        didSet {
            configureType()
        }
    }
    
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
            make.width.height.equalTo(20)
            make.left.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        titlesStack.snp.makeConstraints { make in
            make.left.equalTo(leftIcon.snp.right).inset(-20)
            make.right.equalTo(rightIcon.snp.left).inset(-8)
            make.height.greaterThanOrEqualTo(20)
            make.top.bottom.equalToSuperview().inset(8)
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
        titleLabel.style(.medium, 14)
        titleLabel.textColor = .olchaTextBlack
        
        titlesStack.axis = .vertical
        
        subtitleLabel.style(.regular, 12)
        subtitleLabel.textColor = .olchaLightTextColornnnnnn
    }
    
    func setup(title: String?, subtitle: String? = nil,type: RoomType) {
        self.type = type
        titleLabel.text = title ?? ""
        
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
        }
        subtitleLabel.isHidden = (subtitle == nil)
    }
    
    private func configureType() {
        switch type {
            case .title:
                leftIcon.image = .search_white?.withColor(.olchaLightTextColornnnnnn ?? .gray)
                rightIcon.setIcon(.rightIcon?.withColor(.olchaLightTextColornnnnnn ?? .gray))
            break
            
            case .history:
                leftIcon.image = .history
                rightIcon.setIcon(.x_cancel)
            break
        }
    }
}
