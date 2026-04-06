//
//  InvestWarningView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 25/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class InvestWarningView: BaseView {

    private let warningLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.numberOfLines = 0
        label.textColor = .olchaBlackNeutral
        return label
    }()
    
    public override func setupViews() {
        self.addSubview(warningLabel)
    }
    
    public override func autolayout() {
        warningLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        self.round(10)
        self.backgroundColor = .lightGrayBackground
    }

    public func setWarningText(_ text: String) {
        warningLabel.text = text
    }
    
}
