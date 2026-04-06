//
//  ProfileView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 30/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class ProfileView: BaseView {
    
    private let profileStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()
    
    private let profileLabelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18.0)
        label.textColor = .olchaShadeBlack
        return label
    }()
    
    private let subNameLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14.0)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    public let button: IButton = {
        let button = IButton()
        return button
    }()
    public override func setupViews() {
        self.addSubview(profileStack)
        profileStack.addArrangedSubview(profileImageView)
        profileStack.addArrangedSubview(profileLabelStack)
        profileLabelStack.addArrangedSubview(nameLabel)
        profileLabelStack.addArrangedSubview(subNameLabel)
        self.addSubview(button)
    }
    
    public override func autolayout() {
        profileStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(56)
        }
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        profileImageView.image = .profile_person
        round()
    }
    
    public func setNameLabel(_ text: String) {
        nameLabel.text = text
    }
    
    public func setSubNameLabel(_ text: String) {
        subNameLabel.text = text
    }
    
}
