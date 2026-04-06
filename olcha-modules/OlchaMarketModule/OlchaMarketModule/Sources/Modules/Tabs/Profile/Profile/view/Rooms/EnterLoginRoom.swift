//
//  EnterLoginRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/09/22.
//

import UIKit
import CoreMedia
import OlchaUI
class EnterLoginRoom: BaseTableCell {
    
    private let titleLabel = UILabel()
    
    private let subtitleLabel = UILabel()
    
    let enterButton = OlchaButton()
  
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)
        container.addSubview(enterButton)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 16
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
        }
        
        enterButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).inset(-16)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        container.round()
        container.darkBorder()
        
        titleLabel.style(.bold, 18)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.textAlignment = .center
        
        titleLabel.numberOfLines = 0
        
        subtitleLabel.style(.medium, 16)
        subtitleLabel.textColor = .olchaTextBlack
        subtitleLabel.textAlignment = .center
        
        subtitleLabel.numberOfLines = 0
        
        
        
    }
    
 
    func setup() {
        titleLabel.text = "guest_login_title".localized()
        subtitleLabel.text = "guest_login_subtitle".localized()
        enterButton.setTitle("guest_login_button".localized())
    }
}
