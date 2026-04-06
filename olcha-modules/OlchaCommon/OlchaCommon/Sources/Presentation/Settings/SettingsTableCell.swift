//
//  SettingsTableCell.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 31/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class SettingsTableCell: BaseTableCell {
    
    public var switchValueObserver: ((Bool) -> Void)?
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14.0)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    private let rightStack: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14.0)
        label.textColor = .olchaPrimaryColor
        label.isHidden = true
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private let switchView: UISwitch = {
        let switchButton = UISwitch()
        switchButton.onTintColor = .olchaPrimaryColor
        switchButton.isHidden = true
        return switchButton
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        rightStack.arrangedSubviews.forEach { view in
            view.isHidden = true
        }
    }
    
    public override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(rightStack)
        rightStack.addArrangedSubview(rightLabel)
        rightStack.addArrangedSubview(iconImageView)
        rightStack.addArrangedSubview(switchView)
    }
    
    public override func autolayout() {
        horizontalEdge = 16
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(44)
        }
        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(16)
        }
    }
    
    public override func configureViews() {
        iconImageView.image = .angleRightB?.withTintColor(.olchaPrimaryColor)
    }
    
    public func setup(with data: SettingsRow) {
        titleLabel.text = data.title
    }
    
    public func setRightLabel(_ text: String) {
        rightLabel.text = text
        rightLabel.isHidden = false
    }
    
    public func setIconVisible() {
        iconImageView.isHidden = false
    }
    
    public func setSwitchVisible() {
        switchView.isHidden = false
        switchView.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    public func setSwitchValue(isOn: Bool) {
        switchView.setOn(isOn, animated: true)
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        switchValueObserver?(sender.isOn)
    }
    
}
