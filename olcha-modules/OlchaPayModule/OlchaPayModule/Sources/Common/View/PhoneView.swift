//
//  PhoneView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 08/05/24.
//

import UIKit
import OlchaUI
public class PayPhoneField: BaseView {

    private let topHintLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .black
        label.text = "pay_mobile_net".localized()
        return label
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.round()
        view.backgroundColor = .olchaWhite
        return view
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.text = "+998"
        label.textColor = .olchaTextBlack
        return label
    }()
    
    lazy var settings: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = .style(.medium, 16)
        textField.textColor = .olchaTextBlack
        textField.delegate = self
        textField.placeholder = .phonePlaceholder
        textField.addTarget(self,
                           action: #selector(textFieldEditingChanged(_:)),
                           for: .allEvents)
        textField.addTarget(self,
                           action: #selector(textFieldTextChanged(_:)),
                           for: .editingChanged)
        
        return textField
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaAccentColor
        label.text = " "
        return label
    }()
    
    var isFilled: Bool = false {
        didSet {
            cancelButton.isHidden = !isFilled
            contactButton.isHidden = isFilled
        }
    }
    
    let cancelButton: IconButton = {
        let button = IconButton()
        button.setIcon(.pay_cancel, isIgnoringEdge: true)
        return button
    }()
    
    let contactButton: IconButton = {
        let button = IconButton()
        button.setIcon(.pay_contact, isIgnoringEdge: true)
        return button
    }()
    
    private let fieldMask = TFieldMobilePhoneMask()
    private let rule = TextFieldRules.shared.shortPhoneRule
    private var textEditing: (() -> Void)?
    private var textChanged: (() -> Void)?
    
    let payButton: IButton = {
        let button = IButton()
        button.setTitle("pay".localized(), for: .normal)
        button.titleLabel?.style(.medium, 16)
        button.setTitleColor(.olchaTextBlack, for: .normal)
        button.round()
        button.backgroundColor = .olchaWhite
        return button
    }()
    
    public override func setupViews() {
        addSubview(topHintLabel)
        addSubview(container)
        addSubview(errorLabel)
        addSubview(payButton)
        
        container.addSubview(codeLabel)
        container.addSubview(settings)
        container.addSubview(cancelButton)
        container.addSubview(contactButton)
    }
    
    public override func autolayout() {
        topHintLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(container.snp.top).inset(-8)
        }
        
        container.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(payButton.snp.left).inset(-10)
            make.height.equalTo(44)
        }
        
        payButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(container.snp.top)
            make.bottom.equalTo(container.snp.bottom)
            make.width.equalTo(100)
        }
        
        codeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(44)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
        }
        
        contactButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.centerX.equalTo(cancelButton.snp.centerX)
        }
        
        settings.snp.makeConstraints { make in
            make.left.equalTo(codeLabel.snp.right).inset(-2)
            make.bottom.top.equalToSuperview()
            make.right.equalTo(cancelButton.snp.left).inset(-2)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(container.snp.bottom).inset(-4)
        }
    }
    
    public override func configureViews() {
        isFilled = true
        cancelButton.clicked { [weak self] in
            guard let self else { return }
            settings.text = ""
            settings.sendActions(for: .editingChanged)
        }
    }
    
    func setPhone(value: String?) {
        settings.text = value?.phoneNumber.formatShortPhoneNumber
        settings.sendActions(for: .editingChanged)  
    }
    
    func getValue() -> String {
        settings.text?.phoneNumber ?? ""
    }
    
    @discardableResult
    func isValidated(withMessage: Bool = false, isForced: Bool = false) -> Bool {
        guard !isForced else { return true }
        
        switch settings.validate(with: [rule]) {
        case .valid:
            errorLabel.isHidden = true
            return true
        case .invalid(let message):
            if withMessage {
                errorLabel.text = message
                errorLabel.isHidden = false
            }
            return false
        }
    }
}


extension PayPhoneField: UITextFieldDelegate {
    
    public func observeText(editing: (() -> Void)?) {
        self.textEditing = editing
    }
    
    public func observeTextChanged(editing: (() -> Void)?) {
        self.textChanged = editing
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        defer {
            textField.sendActions(for: .editingChanged)
        }
        
        return fieldMask.execute(textField: textField, range: range, replacingText: string)
    }
    
    @objc public func textFieldEditingChanged(_ textField: UITextField) {
        textEditing?()
        isFilled = !(textField.text == "")
        errorLabel.isHidden = true
    }
    
    @objc public func textFieldTextChanged(_ textField: UITextField) {
        textChanged?()
    }
}
