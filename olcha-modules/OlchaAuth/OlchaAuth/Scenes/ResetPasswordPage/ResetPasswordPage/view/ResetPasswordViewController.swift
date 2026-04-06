//
//  ResetPasswordViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 24/02/23.
//

import UIKit
import OlchaUI
import OlchaUtils
public protocol ResetPasswordViewControllerProtocol: UIViewController {
    var viewModel: AuthViewModel { get set }
    var coordinator: AuthCoordinatorProtocol? { get set }
    var authCompletion: (() -> Void)? { get set }
}
public class ResetPasswordViewController: BaseViewController<BackNavigationBar>, ResetPasswordViewControllerProtocol {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.bold, 24)
        label.textColor = .olchaTextBlack
        label.text = "enter_new_password".localized()
        label.textAlignment = .center
        return label
    }()
    
    private let passwordField1: TField = {
        let field = TField()
        field.field_tag = (\PasswordEditRequest.password).propertyName
        field.type = .password
        field.topHint = "password".localized()
        return field
    }()
    
    private let passwordField2: TField = {
        let field = TField()
        field.field_tag = (\PasswordEditRequest.password_confirmation).propertyName
        field.type = .password
        field.topHint = "retry_new_password".localized()
        return field
    }()
    
    private let acceptButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("register".localized())
        button.configure(type: .pay)
        return button
    }()
    
    public weak var coordinator: AuthCoordinatorProtocol?
    
    public var viewModel: AuthViewModel
    
    public var authCompletion: (() -> Void)?
    
    public override var validatedFields: [TField] {
        [passwordField1, passwordField2]
    }
    
    public init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(passwordField1)
        container.addSubview(passwordField2)
        container.addSubview(acceptButton)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().inset(110)
            make.left.right.equalToSuperview().inset(16)
        }
        
        passwordField1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        passwordField2.snp.makeConstraints { make in
            make.top.equalTo(passwordField1.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        checkButtonState()
    }
    
    public override func setupObservers() {
        
        passwordField1.observeText { [weak self] in
            guard let self = self else { return }
            self.checkButtonState()
        }
        
        passwordField2.observeText { [weak self] in
            guard let self = self else { return }
            self.checkButtonState()
        }
        
        acceptButton.settings.clicked { [weak self] in
            guard let self = self,
                  let phone = self.coordinator?.phone,
                  let code = self.coordinator?.code
            else { return }
            self.viewModel.renewPassword(phone: phone,
                                         password: self.passwordField1.getText(),
                                         password2: self.passwordField2.getText(),
                                         code: code)
        }
        
        handle(viewModel.$renewPasswordPublisher,
               loading: { [weak self] isLoading in
            guard let self = self else { return }
            self.acceptButton.settings.requesting = isLoading
        })
        
        handle(viewModel.$loginPublisher) { [weak self] data in
            guard let self = self,
                  data != nil else { return }
            self.authCompletion?()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showError(text: error?.message)
        } loading: { [weak self] isLoading in
            guard let self = self else { return }
            self.acceptButton.settings.requesting = isLoading
        }

    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        
        animateButton(inset: height + 16)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        animateButton(inset: 16)
    }
    
    private func animateButton(inset: CGFloat) {
        acceptButton.snp.remakeConstraints { make in
            make.top.greaterThanOrEqualTo(passwordField2.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(inset)
        }
            
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
                
    }
    
    private func checkButtonState() {
        
        if passwordField1.isValidated() && passwordField2.isValidated() {
            acceptButton.enableButton()
        } else {
            acceptButton.disableButton()
        }
    }

}
