//
//  SelectFilterItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/07/22.
//

import UIKit
import OlchaUI
class SelectFilterItem: BaseTableCell {

    private let titleLabel = UILabel()
    private let checkBoxItem = UIImageView()
    private let bottomSeparator = UIView()
    var selectButton = Button()
    
    var isChosen: Bool = false {
        didSet {
            checkBoxItem.image = isChosen ? .checked : .unchecked
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.isChosen = false
    }
    
    override func setupViews() {

        self.container.addSubview(titleLabel)
        self.container.addSubview(checkBoxItem)
        self.container.addSubview(bottomSeparator)
        self.container.addSubview(selectButton)
    }
    
    override func autolayout() {
        self.container.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(50)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        self.checkBoxItem.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.left.equalTo(self.titleLabel.snp.right).inset(-8)
        }
        
        self.bottomSeparator.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        self.selectButton.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        self.titleLabel.style(.medium, 14)
        self.titleLabel.textColor = .olchaTextBlack
        
        self.checkBoxItem.image = .unchecked
        self.bottomSeparator.backgroundColor = .olchaLightNeutralDarkGray
        self.selectButton.setTitle("", for: .normal)
        self.selectButton.backgroundColor = .clear
    }
    
    func setup(with data: String) {
        self.titleLabel.text = data
    }
    
}
