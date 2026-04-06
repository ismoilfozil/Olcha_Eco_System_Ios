//
//  NotificationStatusView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 29/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import SnapKit

public class NotificationStatusView: BaseView {
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 2
        stack.alignment = .fill
        return stack
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .celebration?.withTintColor(.olchaOrange ?? .black)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12.0)
        label.textColor = .olchaOrange
        return label
    }()
    
    public override func setupViews() {
        addSubview(contentStack)
        contentStack.addArrangedSubview(iconImageView)
        contentStack.addArrangedSubview(titleLabel)
    }
    
    public override func autolayout() {
        contentStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(6)
            make.verticalEdges.equalToSuperview().inset(4)
        }
    }
    
    public override func configureViews() {
        self.backgroundColor = .olchaOrange
        self.round(6.0)
        languageUpdated()
    }
    
    public override func languageUpdated() {
        titleLabel.text = "notification_congrats".localized(.olchaInvestCore)
    }
    
}
