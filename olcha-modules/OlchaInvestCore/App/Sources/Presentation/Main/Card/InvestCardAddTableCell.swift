//
//  InvestCardAddTableCell.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 23/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class InvestCardAddTableCell: BaseTableCell {
    
    private let plusImageViewContainer: UIView = {
        let view = UIView()
        view.round(8)
        view.backgroundColor = .olchaLightNeutralGray
        return view
    }()
    
    private let plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .plus
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let addCardLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textColor = .olchaBlackNeutral
        return label
    }()
    
    private let arrowRightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .arrowRight
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public override func setupViews() {
        container.addSubview(plusImageViewContainer)
        plusImageViewContainer.addSubview(plusImageView)
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(addCardLabel)
        contentStack.addArrangedSubview(arrowRightImageView)
    }
    
    public override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 8
        
        plusImageViewContainer.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(18)
            make.width.height.equalTo(36)
        }
        plusImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        contentStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(plusImageViewContainer.snp.right).offset(12)
            make.right.equalToSuperview().inset(12)
        }
        arrowRightImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
    }
    
    public override func configureViews() {
        container.backgroundColor = .lightGrayBackground
        container.round(8)
    }
    
    public func setup() {
        addCardLabel.text = "card_add".localized(.olchaInvestCore)
    }
    
}
