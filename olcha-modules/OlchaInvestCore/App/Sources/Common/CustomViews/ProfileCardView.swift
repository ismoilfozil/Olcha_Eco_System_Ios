//
//  ProfileCardView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 30/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class ProfileCardView: BaseView {
    
    private let topStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14.0)
        label.textColor = .white
        return label
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14.0)
        label.textColor = .white
        return label
    }()
    
    private let amountButton: LeftIconButton = {
        let button = LeftIconButton()
        button.setIcon(.plustCircle?.withTintColor(.white), iconSize: 24.0)
        button.titleLabel.style(.semibold, 24.0)
        button.titleLabel.textColor = .white
        button.titleLabel.text = "0 cум"
        button.enableContainer()
        return button
    }()
    
    public override func setupViews() {
        self.addSubview(topStack)
        topStack.addArrangedSubview(titleLabel)
        topStack.addArrangedSubview(idLabel)
        self.addSubview(amountButton)
    }
    
    public override func autolayout() {
        topStack.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        amountButton.snp.makeConstraints { make in
            make.top.equalTo(topStack.snp.bottom).offset(70)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        self.backgroundColor = .olchaPrimaryColor
        self.round(14.0)
    }
    
    public func setTitleLabel(_ text: String) {
        titleLabel.text = text
    }
    
    public func setIdLabel(_ text: String) {
        idLabel.text = text
    }
    
    public func setupAmount(_ text: String) {
        amountButton.setTitle(text)
    }
    
    public func amountButtonClicked(completion: (() -> Void)?) {
        amountButton.settings.clicked { completion?() }
    }
    
}
