//
//  BuyTypeRoom.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 07/02/24.
//

import UIKit
import OlchaUI
class BuyTypeSelectRoom: BaseTableCell {
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    private let titleLabel: HorizontalButton = {
        let button = HorizontalButton()
        button.settings.style(.medium, 16)
        button.settings.textColor = .olchaTextBlack
        button.settings.textAlignment = .left
        button.leftIconSize = 20
        button.setup(leftIcon: .round_unselected_check)
        button.isButtonEnabled = false
        return button
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaLightTextColornnnnnn
        label.numberOfLines = 0
        return label
    }()
    
    let separator = Divide()
    
    let button = IButton()
    
    var isChosen: Bool = false {
        didSet {
            titleLabel.setup(leftIcon: isChosen ? .round_selected_check : .round_unselected_check)
        }
    }
    
    override func setupViews() {
        container.addSubview(containerStackView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(subtitleLabel)
        container.addSubview(separator)
        container.addSubview(button)
    }
    
    override func autolayout() {
        containerStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
 
    func setupState(isEnabled: Bool) {
        button.isEnabled = isEnabled
        if isEnabled {
            titleLabel.settings.textColor = .olchaTextBlack
            titleLabel.setup(leftIcon: isChosen ? .round_selected_check : .round_unselected_check)
        } else {
            titleLabel.settings.textColor = .olchaLightTextColornnnnnn
            titleLabel.setup(leftIcon: .round_unselected_check?.withColor(.olchaLightTextColornnnnnn ?? .gray))
        }
    }
    
    func setup(title: String?, subtitle: String? = nil) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = (subtitle == nil)
    }
}
