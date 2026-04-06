//
//  OlchaBonusItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/02/23.
//

import UIKit
import OlchaAuth
import OlchaUI
class OlchaBonusItem: BaseCollectionCell {
    
    private let balanceTitle = UILabel()
    
    private let idLabel = UILabel()
    
    private let moneyStack = UIStackView()
    
    private let moneyTitle = UILabel()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        skeletonViews.forEach({ $0.layoutSkeletonIfNeeded() })
    }
    
    override func setupViews() {
        container.addSubview(balanceTitle)
        container.addSubview(idLabel)
        container.addSubview(moneyStack)
        moneyStack.addArrangedSubview(moneyTitle)
    }
        
    override func autolayout() {
        container.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
        
        balanceTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(16)
        }
        
        moneyStack.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
    }
    
    override func configureViews() {
        container.round()
        container.backgroundColor = .olchaAccentColor
        
        balanceTitle.style(.medium, 14)
        balanceTitle.textColor = .olchaWhite
        balanceTitle.text = "Olcha Bonus"
        
        idLabel.style(.medium, 14)
        idLabel.textColor = .white
        
        moneyTitle.style(.bold, 24)
        moneyTitle.textColor = .white
        
        moneyStack.axis = .horizontal
        moneyStack.spacing = 8
        
        configureSkeleton()
    }
    
    func setup(with data: Bonus?, user: User?) {
        idLabel.text = "ID: " + (user?.id ?? 0).string
        moneyTitle.text = data?.bonus?.originalPrice
    }
    

  
}

private extension OlchaBonusItem {
    func configureSkeleton() {
        makeSkeleton(views: [
            container
        ])
    }
}
