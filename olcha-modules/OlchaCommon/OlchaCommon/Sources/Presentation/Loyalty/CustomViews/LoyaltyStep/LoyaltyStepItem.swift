//
//  LoyaltyStepItem.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 11/07/24.
//

import UIKit
import OlchaUI

public class LoyaltyStepItem: BaseView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let checkIcon: IconButton = {
        let button = IconButton()
        button.isUserInteractionEnabled = false
        button.round(8)
        return button
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public override func setupViews() {
        addSubview(imageView)
        addSubview(checkIcon)
        addSubview(valueLabel)
    }
    
    public override func autolayout() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        checkIcon.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).inset(-8)
            make.width.height.equalTo(16)
            make.centerX.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(checkIcon.snp.bottom).inset(-3)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func setup(step: LoyaltyStep, isCurrent: Bool) {
        imageView.image = step.image
        valueLabel.text = step.title
        
        checkIcon.backgroundColor = isCurrent ? .olchaAccentColor : .hex("DCDCDC")
        checkIcon.setIcon(isCurrent ? (.check_light?.withColor(.olchaWhite)) : nil, edgeSize: 2, isIgnoringEdge: false)
        
        valueLabel.textColor = isCurrent ? .olchaTextBlack : .olchaLightTextColornnnnnn
        valueLabel.style(isCurrent ? .semibold : .medium, 12)
    }
    
}
