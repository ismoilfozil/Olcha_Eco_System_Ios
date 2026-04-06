//
//  InvestHomeModalTableCell.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 19/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class InvestHomeModalTableCell: BaseTableCell {
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .plustCircle
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Пополнить"
        label.style(.medium, 16)
        label.textColor = .olchaBlackNeutral
        return label
    }()
    
    private let moreIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .angleRightB
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public override func setupViews() {
        container.addSubview(containerStack)
        containerStack.addArrangedSubview(iconImageView)
        containerStack.addArrangedSubview(titleLabel)
        containerStack.addArrangedSubview(moreIconImageView)
    }
    
    public override func autolayout() {
        horizontalEdge = 16
        containerStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(16)
        }
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        moreIconImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
    }
    
    public override func configureViews() {
        
    }
    
    public func setup(with data: TableRowProtocol) {
        iconImageView.image = data.icon
        titleLabel.text = data.title
    }
    
}
