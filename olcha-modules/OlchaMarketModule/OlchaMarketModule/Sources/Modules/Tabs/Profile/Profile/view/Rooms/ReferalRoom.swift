//
//  ReferalRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/09/22.
//

import UIKit
import OlchaUI
class ReferalRoom: BaseTableCell {

    private let titleLabel = UILabel()
    private let subtitle = UILabel()
    private let linkContainer = UIView()
    private let linkLabel = UILabel()
    private let copyContainer = UIView()
    private let copyImageView = UIImageView()
    let copyButton = Button()
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(subtitle)
        container.addSubview(linkContainer)
        linkContainer.addSubview(linkLabel)
        container.addSubview(copyContainer)
        copyContainer.addSubview(copyImageView)
        copyContainer.addSubview(copyButton)
    }
    
    override func autolayout() {
        
        container.snp.remakeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.right.top.left.equalToSuperview().inset(16)
        }
        
        subtitle.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
        }
        
        linkContainer.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(subtitle.snp.bottom).inset(-16)
        }
        
        copyContainer.snp.makeConstraints { make in
            make.left.equalTo(linkContainer.snp.right).inset(-8)
            make.right.bottom.equalToSuperview().inset(16)
            make.width.height.equalTo(40)
        }
        
        linkLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        
        copyImageView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        copyButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        container.round()
        container.border()
        
        titleLabel.style(.bold, 18)
        titleLabel.textColor = .olchaTextBlack
        
        
        subtitle.style(.medium, 14)
        subtitle.textColor = .olchaTextBlack
        
        
        linkContainer.darkBorder()
        linkContainer.round()
        
        linkLabel.style(.medium, 14)
        linkLabel.textColor = .black
        linkLabel.text = "https://olcha.uz/user/referal/"
        linkLabel.lineBreakMode = .byTruncatingTail
        
        copyContainer.backgroundColor = .olchaAccentColor
        copyContainer.round()
        
        copyImageView.image = .copy
    }
    
    
    func setup(with data: Int?) {
        linkLabel.text = Funcs.getReferalLink(id: data)
        staticTexts()
    }
    
    private func staticTexts() {
        titleLabel.text = "call_friends".localized()
        subtitle.text = "get_bonuses".localized()
    }
}
