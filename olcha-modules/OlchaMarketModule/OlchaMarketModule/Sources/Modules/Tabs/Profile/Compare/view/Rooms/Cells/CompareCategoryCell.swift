//
//  CompareCategoryCell.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 16/08/22.
//

import UIKit
import OlchaUI
class CompareCategoryCell: BaseCollectionCell {
    
    private let titleLabel = UILabel()
    
    var isChosen: Bool = false {
        didSet {
            titleLabel.textColor = isChosen ? .olchaWhite : .olchaTextBlack
            container.backgroundColor = isChosen ? .olchaAccentColor : .white
            container.layer.borderWidth = isChosen ? 0 : 1
        }
    }
    
    override func setupViews() {
        container.addSubview(titleLabel)
    }
    
    override func autolayout() {
        container.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(3)
                make.top.bottom.equalToSuperview()
            make.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(6)
        }
    }
    
    override func configureViews() {
        titleLabel.style(.medium, 14)
        titleLabel.textColor = .olchaTextBlack
        
        container.border()
        container.round(16)
    }

    func setup(with data: String) {
        titleLabel.text = data
    }

}
