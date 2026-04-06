//
//  DefaultAlert.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 08/02/24.
//

import UIKit
import OlchaUtils

class DefaultAlert: BaseView {
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaWhite
        view.round()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 24)
        label.textAlignment = .center
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 18)
        label.textColor = .olchaLightTextColornnnnnn
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let closeButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("understand".localized())
        return button
    }()
    
    weak var delegate: BaseAlertDelegate?
    
    override func setupViews() {
        addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(contentLabel)
        container.addSubview(closeButton)
    }
    
    override func autolayout() {
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(34)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(35)
            make.top.equalTo(titleLabel.snp.bottom).inset(-30)
        }
        
        closeButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(30)
            make.top.equalTo(contentLabel.snp.bottom).inset(-30)
        }
    }
    
    override func configureViews() {
        closeButton.clicked { [weak self] in
            guard let self else { return }
            delegate?.dismiss()
        }
    }
    
    func setup(title: String?, content: String?, buttonTitle: String = "understand".localized()) {
        titleLabel.text = title
        contentLabel.text = content
        closeButton.setTitle(buttonTitle)
    }
}
