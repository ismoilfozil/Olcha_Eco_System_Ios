//
//  PhoneField.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 02/02/23.
//

import Foundation
public class PayField: TField {
    public lazy var rightButton: IButton = {
        let button = IButton()
        button.titleLabel?.style(.medium, 16)
        button.setTitleColor(.olchaTextBlack, for: .normal)
        button.setTitle("pay".localized(), for: .normal)
        return button
    }()
    
    public init() {
        super.init(frame: .zero)
        baseSetup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        rightButtonContainer.addSubview(rightButton)
    }
    
    private func autolayout() {
        rightButton.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(8)
        }
    }
    
    private func configureViews() {
        background = .olchaWhite
        type = .shortPhone
        canUseRules = false
    }
    
    public func languageUpdated() {
        rightButton.setTitle("pay".localized(), for: .normal)
    }
}

