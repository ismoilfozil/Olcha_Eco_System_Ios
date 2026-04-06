//
//  FilterItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/07/22.
//

import UIKit
import OlchaUI
class FilterItem: BaseCollectionCell, ChoosableCell {
    
    private let titleLabel = UILabel()
    
    private let disableContainer = UIView()
    
    var isChosen: Bool = false {
        didSet {
            titleLabel.textColor = isChosen ? .olchaWhite : .olchaTextBlack
            container.backgroundColor = isChosen ? .olchaAccentColor : .olchaLightNeutralGray
        }
    }
    
    var enabled: Bool = false {
        didSet {
            disableContainer.isHidden = enabled
        }
    }
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(disableContainer)
    }
    
    override func autolayout() {
        container.snp.remakeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.height.equalTo(32)
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width - 32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(6)
        }
        
        disableContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        titleLabel.style(.medium, 14)
        titleLabel.textColor = .olchaTextBlack
        container.round(16)
        
        disableContainer.backgroundColor = .lightGrayBackground?.withAlphaComponent(0.65)
    }

    func setup(with data: String) {
        self.titleLabel.text = data
        self.isHidden = data.isEmpty
    }
}
