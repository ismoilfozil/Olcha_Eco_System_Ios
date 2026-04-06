//
//  HomeCardListRoom.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 04/02/23.
//

import UIKit
import OlchaUI
import OlchaUtils
class HomeCardListRoom: BaseTableCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaDarkGray
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.style(.bold, 18)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private lazy var dotIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .radio_unselected
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    var isChosen: Bool = false {
        didSet {
            dotIcon.image = isChosen ? .radio_selected : .radio_unselected
        }
    }
    
    var isSelectable: Bool = false {
        didSet {
            dotIcon.isHidden = !isSelectable
        }
    }
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        container.addSubview(dotIcon)
    }
    
    override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
            make.bottom.equalToSuperview()
            make.right.equalTo(titleLabel.snp.right)
        }
        
        dotIcon.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(titleLabel.snp.right).inset(-8)
            make.centerY.equalToSuperview()
        }
    }
    
    func setup(model: UserBankCardModel) {
        titleLabel.text = model.bankName
        valueLabel.text = model.balanceAmount
    }
    
    
}
