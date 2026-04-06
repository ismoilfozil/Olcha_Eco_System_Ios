//
//  EditPasswordModalPage.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 24/05/23.
//

import Combine
import UIKit
import OlchaUI
public protocol EditPasswordModalPageProtocol: BaseModalViewController {
    var viewModel: AuthViewModel { get set }
}

public class EditPasswordModalPage: BaseModalViewController {

    private lazy var passwordField: TField = {
        let field = TField()
        field.field_tag = (\PasswordEditRequest.password).propertyName
        field.topHint = "password".localized()
        field.type = .password
        return field
    }()
    
    private lazy var passwordField2: TField = {
        let field = TField()
        field.field_tag = (\PasswordEditRequest.password_confirmation).propertyName
        field.topHint = "retry_new_password".localized()
        field.type = .password
        return field
    }()
    
    private lazy var acceptButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("save".localized())
        button.configure(type: .pay)
        return button
    }()
    
    var viewModel: AuthViewModel
    
    public override var validatedFields: [TField] {
        return [
            passwordField,
            passwordField2
        ]
    }
    
    public init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(passwordField)
        container.addSubview(passwordField2)
        container.addSubview(acceptButton)
    }
    
    public override func autolayout() {
        passwordField.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(16)
        }
        
        passwordField2.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(passwordField.snp.bottom).inset(-16)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField2.snp.bottom).inset(-16)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }
    
    
    public override func configureViews() {
        setHeader(title: "edit_password".localized())
        dismissConfiguration()
    }
    
    public override func initialRequest() {
        checkButtonState()
    }
        
    public override func setupObservers() {
        
        passwordField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkButtonState()
        }
        
        passwordField2.observeText { [weak self] in
            guard let self = self else { return }
            self.checkButtonState()
        }
        
        acceptButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.viewModel.editPassword(password: self.passwordField.getValue(),
                                        password2: self.passwordField2.getValue())
        }
        
        
        
        handle(viewModel.$editPasswordPublisher,
               success: { [weak self] data in
            guard let self = self else { return }
            self.showSuccess(text: "password_updated".localized()) {
                self.dismiss(animated: true)
            }
        }, loading:  { [weak self] isLoading in
            guard let self = self else { return }
            self.acceptButton.settings.requesting = isLoading
        })
    }
    
    private func checkButtonState() {
        if passwordField.isValidated() && passwordField2.isValidated() {
            acceptButton.enableButton()
        } else {
            acceptButton.disableButton()
        }
    }
}
