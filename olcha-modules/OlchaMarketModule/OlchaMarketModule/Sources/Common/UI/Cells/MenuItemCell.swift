//
//  MenuItemCell.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/07/22.
//

import UIKit
import OlchaUI
class MenuItemCell: BaseTableCell {
    private let titleLabel = UILabel()
    
    override func setupViews() {
        self.container.addSubview(titleLabel)
    }
    
    override func autolayout() {
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(8)
        }
    }
    
    override func configureViews() {
        self.container.backgroundColor = .clear
        self.container.round(8)
        self.titleLabel.style(.medium, 14)
        self.titleLabel.textColor = .olchaTextBlack
    }
    
    func setup(with data: String, isSelected: Bool) {
        self.titleLabel.text = data
        self.container.backgroundColor = isSelected ? .olchaLightNeutralGray : .clear
    }
}
