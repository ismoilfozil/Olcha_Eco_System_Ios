//
//  InvestTField.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 22/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class InvestTField: TField {
    
    private enum FieldState {
        case `default`
        case error
        case success
    }
    
    public var isEditing: Bool = false
    
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        settings.becomeFirstResponder()
        return settings.canBecomeFirstResponder
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        settings.resignFirstResponder()
        return settings.canResignFirstResponder
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        
    }
    
    private func autolayout() {
        topHintLabel.snp.updateConstraints { make in
            make.left.equalToSuperview().inset(5)
        }
        textFieldContainer.snp.updateConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    public func configureViews() {
        textFieldContainer.round(8)
        setTextFieldBorder(state: .default)
        topHintLabel.style(.regular, 16)
        settings.font = .style(.regular, 16)
        settings.textColor = .olchaNeutral700
        rightButtonContainer.isUserInteractionEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldTapped))
        textFieldContainer.addGestureRecognizer(tapGesture)
    }
    
    @objc private func textFieldTapped() {
        settings.becomeFirstResponder()
    }
    
    public override func errorStyle(_ bottomHint: String? = "") {
        fieldState = .error
        self.bottomHint = bottomHint ?? ""
        bottomHintLabel.textColor = .olchaAccentColor
        setTextFieldBorder(state: .error)
    }
    
    public override func defaultStyle() {
        fieldState = .def
        bottomHint = ""
        setTextFieldBorder(state: .default)
    }
    
    public func setFieldDisabled() {
        settings.isEnabled = false
        textFieldContainer.backgroundColor = .olchaLightNeutralGray
    }
    
    public func setFieldEnabled() {
        settings.isEnabled = true
        textFieldContainer.backgroundColor = .clear
    }
    
    public func setDisabled() {
        settings.isEnabled = false
    }
    
    public func setDisabledBackground() {
        textFieldContainer.backgroundColor = .olchaLightNeutralGray
    }
    
    public func disableEditing(withBackground: Bool = false) {
        isUserInteractionEnabled = false
        textFieldContainer.backgroundColor = withBackground ? .olchaLightNeutralGray : .olchaWhite
    }
    
    public func enableEditing() {
        isUserInteractionEnabled = true
        textFieldContainer.backgroundColor = .olchaWhite
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        isEditing = true
        setTextFieldBorder(state: isValidated() ? .default : .error)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        isEditing = false
        setTextFieldBorder(state: isValidated() ? .default : .error)
    }
    
    private func setTextFieldBorder(state: FieldState) {
        switch state {
        case .default:
            textFieldContainer.border(with: isEditing ? .olchaTextBlack : .olchaLightNeutralDarkGray)
        case .error:
            textFieldContainer.border(with: .olchaAccentColor)
        case .success:
            textFieldContainer.border(with: .olchaGreen)
        }
    }
    
    public func addRule(_ rule: @escaping TextFieldValidationRule) {
        rules.append(rule)
    }
    
}
