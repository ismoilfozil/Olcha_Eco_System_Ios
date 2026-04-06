//
//  SelectRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/10/22.
//

import UIKit
import OlchaUI
class SelectRoom: BaseTableCell {

    private let radioIcon = UIImageView()
    
    private let titleLabel = UILabel()
    
    private let separator = Divide()
    
    override func setupViews() {
        container.addSubview(radioIcon)
        container.addSubview(titleLabel)
        container.addSubview(separator)
    }
    
    override func autolayout() {
        radioIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(radioIcon.snp.right).inset(-8)
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        radioIcon.isUserInteractionEnabled = false
        titleLabel.style(.medium, 16)
        titleLabel.textColor = .olchaTextBlack
    }
    
    
    func setup(with data: LanguageModel) {
        titleLabel.text = data.value
        
        radioIcon.image = (String.getAppLanguage() == data.key.rawValue) ? .round_selected_check : .round_unselected_check
    }
    
}
