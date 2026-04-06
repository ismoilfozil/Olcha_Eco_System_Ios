//
//  ContractPauseReasonTableCell.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 03/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class ContractPauseReasonTableCell: BaseTableCell {
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 16.0)
        label.textColor = .olchaBlackNeutral
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .rbtnDefault
        return imageView
    }()
    
    public var isChosen: Bool = false {
        didSet {
            iconImageView.image = isChosen ? .rbtn : .rbtnDefault
            titleLabel.textColor = isChosen ? .olchaPrimaryColor : .olchaBlackNeutral
        }
    }
    
    public override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(iconImageView)
        contentStack.addArrangedSubview(titleLabel)
    }
    
    public override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 14
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(20)
        }
    }
    
    public func setTitleLabel(_ text: String) {
        titleLabel.text = text
    }

}
