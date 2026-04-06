//
//  LoginViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 26/01/23.
//

import UIKit
import Combine
import IQKeyboardManagerSwift
import OlchaUI
public protocol LoginViewControllerProtocol: UIViewController {
    var coordinator: AuthCoordinatorProtocol? { get set }
    var viewModel: AuthViewModel { get set }
    var authCompletion: (() -> Void)? { get set }
    var resetPasswordObserver: (() -> Void)? { get set }
}
public class LoginViewController: BaseViewController<BackNavigationBar>, LoginViewControllerProtocol {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.bold, 24)
        label.textColor = .olchaTextBlack
        label.text = "login".localized()
        label.textAlignment = .center
        return label
    }()
    
    private let phoneField: TField = {
        let field = TField()
        field.type = .shortPhone
        field.topHint = "phone_number".localized()
        field.isUserInteractionEnabled = false
        return field
    }()
    
    private let passwordField: TField = {
        let field = TField()
        field.topHint = "password".localized()
        field.type = .password
        return field
    }()
    
    private let resetPassword: IButton = {
        let button = IButton()
        button.setTitleColor(.olchaAccentColor, for: .normal)
        button.setTitle("forgot_password".localized(), for: .normal)
        button.titleLabel?.style(.medium, 14)
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaPrimaryColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.isHidden = true
        return label
    }()
    
    private let acceptButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("login".localized())
        button.configure(type: .pay)
        return button
    }()
    
    public weak var coordinator: AuthCoordinatorProtocol?
    
    public var authCompletion: (() -> Void)?
    public var resetPasswordObserver: (() -> Void)?
    
    public var viewModel: AuthViewModel
    
    public init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(phoneField)
        container.addSubview(passwordField)
        container.addSubview(errorLabel)
        container.addSubview(resetPassword)
        container.addSubview(acceptButton)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().inset(110)
            make.left.right.equalToSuperview().inset(16)
        }
        
        phoneField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(phoneField.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        resetPassword.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(errorLabel.snp.bottom).inset(-16)
        }
       
        acceptButton.snp.remakeConstraints { make in
            make.top.greaterThanOrEqualTo(resetPassword.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        phoneField.setPhone(number: coordinator?.phone)
        checkButtonState()
    }
    
    public override func setupObservers() {

        phoneField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkButtonState()
        }
        
        passwordField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkButtonState()
        }
        
        resetPassword.clicked { [weak self] in
            guard let self = self else { return }
            IQKeyboardManager.shared.resignFirstResponder()
            self.resetPasswordObserver?()
        }
        
        acceptButton.clicked { [weak self] in
            guard let self = self else { return }
            self.viewModel.login(phone: self.phoneField.getPhone(),
                                 password: self.passwordField.getValue())
        }
        
        handle(viewModel.$loginPublisher, withError: false, success: { [weak self] data in
            guard let self = self else { return }
            self.authCompletion?()
        }, failure: { [weak self] error in
            guard let self else { return }
            errorLabel.text = error?.message
            errorLabel.isHidden = false
        }, loading: { [weak self] isLoading in
            guard let self = self else { return }
            self.acceptButton.settings.requesting = isLoading
        })
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
            make.top.greaterThanOrEqualTo(resetPassword.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(inset)
        }
            
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func checkButtonState() {
        errorLabel.text = nil
        errorLabel.isHidden = true
        
        let isEnabled = phoneField.isValidated() && passwordField.isValidated()
        isEnabled ? acceptButton.enableButton() : acceptButton.disableButton()
    }
}
