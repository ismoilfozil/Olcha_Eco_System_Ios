//
//  ProfileDataHeaderRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 23/09/22.
//

import UIKit
import OlchaUI
class ProfileDataHeaderRoom: BaseTableCell {

   
    private let titleLabel = UILabel()
    
    private let separator = Divide()
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(separator)
    }
    
    override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(separator.snp.top).inset(-16)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        titleLabel.style(.bold, 18)
        titleLabel.textColor = .olchaTextBlack
    }
    
    func setup(with title: String) {
        titleLabel.text = title
    }
}
