//
//  OrderStepRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/10/22.
//

import UIKit
import OlchaUI
class OrderStepRoom: BaseTableCell {
    
    
    
    private let stepLabel = Label()
    
    private let titlesStack = UIStackView()
    
    private let titleLabel = UILabel()
    
    private let subtitleLabel = UILabel()
    
    private let dotsLabel = UILabel()
    
    override func setupViews() {
        
        container.addSubview(dotsLabel)
        container.addSubview(stepLabel)
        container.addSubview(titlesStack)
        titlesStack.addArrangedSubview(titleLabel)
        titlesStack.addArrangedSubview(subtitleLabel)
    }
    
    override func autolayout() {
        
        stepLabel.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.left.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        titlesStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.left.equalTo(stepLabel.snp.right).inset(-8)
            make.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(26)
        }
        
        dotsLabel.snp.makeConstraints { make in
            make.left.equalTo(stepLabel.snp.left)
            make.right.equalTo(stepLabel.snp.right)
            make.top.equalTo(stepLabel.snp.top)
        }
    }
    
    override func configureViews() {
        container.clipsToBounds = true
        
        titlesStack.axis = .vertical
        titlesStack.spacing = 8
        
        stepLabel.round(8)
        stepLabel.settings.style(.medium, 14)
        stepLabel.settings.textAlignment = .center
        stepLabel.backgroundColor = .white
        stepLabel.border()
        
        titleLabel.style(.semibold, 16)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.numberOfLines = 0
        
        subtitleLabel.numberOfLines = 0
        subtitleLabel.style(.medium, 14)
        subtitleLabel.textColor = .olchaDarkGray
        
        dotsLabel.numberOfLines = 0
        dotsLabel.textAlignment = .center
        dotsLabel.text = "|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n||\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n||\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|"
        dotsLabel.textColor = .olchaLightNeutralDarkGray
        
    }
    
    func setup(with data: OrderStatus,
               index: Int,
               isLast: Bool) {
        
        let isActive = data.active ?? false
        
        titleLabel.text = data.name
        subtitleLabel.text = data.created_at?.formated_date
        
        subtitleLabel.isHidden = (data.created_at == "")
        
        stepLabel.text = index.string
        
        dotsLabel.isHidden = isLast
        
        stepLabel.backgroundColor = isActive ? .olchaAccentColor : .white
        stepLabel.border(with: isActive ? .olchaAccentColor : .olchaLightNeutralGray)
        stepLabel.settings.textColor = isActive ? .olchaWhite : .olchaTextBlack
        
        dotsLabel.textColor = isActive ? .olchaAccentColor : .olchaLightNeutralDarkGray
    }
}
