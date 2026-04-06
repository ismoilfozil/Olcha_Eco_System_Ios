//
//  NotificationHeaderItem.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 20/02/24.
//

import UIKit
import OlchaUI
class NotificationHeaderItem: BaseCollectionCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let disableContainer = UIView()
    
    var isChosen: Bool = false {
        didSet {
            titleLabel.textColor = isChosen ? .olchaWhite : .olchaTextBlack
            container.backgroundColor = isChosen ? .olchaBlackNeutral : .olchaLightNeutralGray
        }
    }
    
    override func setupViews() {
        container.addSubview(titleLabel)
    }
    
    override func autolayout() {
        container.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width - 32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(6)
        }
        
    }
    
    override func configureViews() {
        container.round(8)
    }
    
    func setup(with data: String) {
        self.titleLabel.text = data
//        self.isHidden = data.isEmpty
    }
}

