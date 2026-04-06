//
//  MenuViewControllerTableCell.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 30/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class MenuViewControllerTableCell: BaseTableCell {
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
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
        label.style(.medium, 16)
        label.textColor = .olchaBlackNeutral
        label.numberOfLines = 0
        return label
    }()
    
    public override func setupViews() {
        container.addSubview(containerStack)
        containerStack.addArrangedSubview(iconImageView)
        containerStack.addArrangedSubview(titleLabel)
    }
    
    public override func autolayout() {
        horizontalEdge = 16
        containerStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(16)
        }
        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
    }
    
    public override func configureViews() {
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    public func setup(with data: MenuRow) {
        titleLabel.textColor = data == .logout ? .olchaPrimaryColor : .olchaBlackNeutral
        iconImageView.image = data.icon
        titleLabel.text = data.title
    }
    
}
