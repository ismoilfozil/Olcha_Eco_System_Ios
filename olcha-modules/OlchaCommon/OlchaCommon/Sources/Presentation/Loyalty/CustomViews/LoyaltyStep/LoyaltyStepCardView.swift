//
//  LoyaltyStepCardView.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 10/07/24.
//

import UIKit
import OlchaUI

public class LoyaltyStepCardView: BaseView {
    
    private let container: UIView = {
        let view = UIView()
        view.round(10)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let rightAnchorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .rightIcon?.withColor(.black)
        return imageView
    }()
    
    private let stepsView = LoyaltyStepView()
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)
        container.addSubview(amountLabel)
        container.addSubview(rightAnchorImageView)
        container.addSubview(stepsView)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(14)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(14)
            make.top.equalTo(titleLabel.snp.bottom).inset(-2)
        }
        
        rightAnchorImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(26)
            make.right.equalToSuperview().inset(14)
            make.width.height.equalTo(18)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rightAnchorImageView.snp.centerY)
            make.right.equalTo(rightAnchorImageView.snp.left).inset(-8)
        }
        
        stepsView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).inset(-12)
            make.left.right.bottom.equalToSuperview().inset(14)
        }
        
    }
    
    public override func configureViews() {
        container.backgroundColor = .hex("F4F4F4")
    }
    
}
