//
//  InvestHomeAddTableCell.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 19/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class InvestHomeAddTableCell: BaseTableCell {
    
    private let addButton: IconButton = {
        let button = IconButton()
        button.setIcon(.addButton)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let addTitle: UILabel = {
        let label = UILabel()
        label.textColor = .olchaBlackNeutral
        label.style(.semibold, 16.0)
        label.textAlignment = .center
        return label
    }()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        container.setNeedsLayout()
        layoutIfNeeded()
        container.addLineDashedStroke(pattern: [10, 10], radius: 4.0, color: UIColor.lightGrayBackground1!.cgColor)
    }
    
    public override func setupViews() {
        container.addSubview(addButton)
        container.addSubview(addTitle)
    }
    
    public override func autolayout() {
        container.snp.remakeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(8)
            make.height.equalTo(176)
        }
        addButton.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        addTitle.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        container.round(14.0)
    }
    
    public func setup() {
        addTitle.text = "home_invest".localized(.olchaInvestCore)
    }
    
}
