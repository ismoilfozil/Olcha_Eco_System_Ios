//
//  SubscribeView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 05/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class SubscribeView: BaseView {
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    private let subscribeLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16.0)
        label.textColor = .olchaTextBlack
        label.textAlignment = .center
        return label
    }()
    
    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    private let fbButton: IconButton = {
        let button = IconButton()
        button.round()
        button.backgroundColor = .olchaPrimaryColor
        button.setIcon(.facebook, edgeSize: 8, isIgnoringEdge: false)
        return button
    }()
    
    private let igButton: IconButton = {
        let button = IconButton()
        button.round()
        button.backgroundColor = .olchaPrimaryColor
        button.setIcon(.instagram, edgeSize: 8, isIgnoringEdge: false)
        return button
    }()
    
    private let tgButton: IconButton = {
        let button = IconButton()
        button.round()
        button.backgroundColor = .olchaPrimaryColor
        button.setIcon(.telegram, edgeSize: 8, isIgnoringEdge: false)
        return button
    }()
    
    public override func setupViews() {
        self.addSubview(contentStack)
        contentStack.addArrangedSubview(subscribeLabel)
        contentStack.addArrangedSubview(buttonStack)
        buttonStack.addArrangedSubview(fbButton)
        buttonStack.addArrangedSubview(igButton)
        buttonStack.addArrangedSubview(tgButton)
    }
    
    public override func autolayout() {
        contentStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(20)
        }
        [fbButton, igButton, tgButton].forEach { iconButton in
            iconButton.snp.makeConstraints { make in
                make.height.width.equalTo(48)
            }
        }
    }
    
    public override func configureViews() {
        self.backgroundColor = .white
        languageUpdated()
    }
    
    public override func languageUpdated() {
        subscribeLabel.text = "subscribe_us".localized(.olchaInvestCore)
    }

    public func fbButtonClicked(completion: @escaping (() -> Void)) {
        fbButton.clicked(action: completion)
    }
    
    public func igButtonClicked(completion: @escaping (() -> Void)) {
        igButton.clicked(action: completion)
    }
    
    public func tgButtonClicked(completion: @escaping (() -> Void)) {
        tgButton.clicked(action: completion)
    }
    
}
