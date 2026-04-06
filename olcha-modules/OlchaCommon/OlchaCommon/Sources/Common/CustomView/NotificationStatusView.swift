//
//  NotificationStatusView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 29/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

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
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
    }
    
    public override func configureViews() {
        self.round(6.0)
    }
    
    public func setTitle(text: String?) {
        titleLabel.text = text
    }
    
    public func setIcon(image: String?) {
        iconImageView.load(from: image)
    }
    
    public func setStatus(color: UIColor?) {
        backgroundColor = color?.withAlphaComponent(0.3)
        iconImageView.tintColor = color
    }
}
