//
//  ShippingDataModalPage.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 06/02/24.
//

import UIKit
import OlchaUI
class ShippingDataModalPage: BaseModalViewController {
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaLightTextColornnnnnn
        label.numberOfLines = 0
        return label
    }()
    
    private let closeButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("understand".localized())
        return button
    }()
    
    var text: String? = "" {
        didSet {
            titleLabel.text = text
        }
    }
    
    override func setupViews() {
        container.addSubview(containerStackView)
        containerStackView.addArrangedSubview(titleLabel)
        container.addSubview(closeButton)
    }
    
    override func autolayout() {
        containerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(containerStackView.snp.bottom).inset(-40)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        setHeader(title: "delivery".localized())
        xButton.isHidden = true
    }
    
    override func setupObservers() {
        closeButton.clicked { [weak self] in
            guard let self else { return }
            dismiss(animated: true)
        }
    }
    
}
