//
//  ResetPasswordPhoneViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 24/02/23.
//

import UIKit
import OlchaUI
import IQKeyboardManagerSwift
public protocol ResetPasswordPhoneViewControllerProtocol: UIViewController {
    var viewModel: AuthViewModel { get set }
    var coordinator: AuthCoordinatorProtocol? { get set }
    var pushResetPassword: (() -> Void)? { get set }
    var pushConfirmCode: ((ConfirmCodeHelper) -> Void)? { get set }
}
open class ResetPasswordPhoneViewController: BaseViewController<BackNavigationBar>, ResetPasswordPhoneViewControllerProtocol {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.bold, 24)
        label.textColor = .olchaTextBlack
        label.textAlignment = .center
        label.text = "reset_password".localized()
        return label
    }()
    
    private let phoneField: TField = {
        let field = TField()
        field.topHint = "phone_number".localized()
        field.type = .shortPhone
        return field
    }()
    
    private let acceptButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("receive_code".localized())
        button.configure(type: .pay)
        return button
    }()
    
    public let authHelper = ConfirmCodeHelper()

    public var viewModel: AuthViewModel
    
    public weak var coordinator: AuthCoordinatorProtocol?
    
    public var pushResetPassword: (() -> Void)?
    
    public var pushConfirmCode: ((ConfirmCodeHelper) -> Void)?
    
    public init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(phoneField)
        container.addSubview(acceptButton)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().inset(110)
            make.left.right.equalToSuperview().inset(16)
        }
        
        phoneField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).inset(-24)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(16)
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
        
        acceptButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.phone = self.phoneField.getPhone()
            IQKeyboardManager.shared.resignFirstResponder()
            phoneField.errorMessage()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.pushConfirmCode?(self.authHelper)
            }
        }
        
        authHelper.sendCodeObserver.sink { [weak self] canSend in
            guard let self = self,
                  let phone = self.coordinator?.phone,
                  canSend else { return }
            self.viewModel.confirmCode(phone: phone)
        }.store(in: &bag)
        
        authHelper.codeConfirmObserver.sink { [weak self] code in
            guard let self = self,
                  let phone = self.coordinator?.phone,
                  code.count == 5
            else { return }
            self.coordinator?.code = code
            self.viewModel.resetPhoneCode(phone: phone, code: code)
        }.store(in: &bag)
        
        handle(viewModel.$resetPhonePublisher) { [weak self] data in
            guard let self = self,
                  data != nil else { return }
            self.authHelper.dismissObserver.send(true)
            self.pushResetPassword?()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.authHelper.errorObserver.send(error?.message ?? "")
            phoneField.errorMessage(error?.message ?? "")
        } loading: { [weak self] isLoading in
            guard let self = self else { return }
            self.authHelper.requestingObserver.send(isLoading)
        }

        handle(viewModel.$sendConfirmCodePublisher,
               showLoader: true,
               withError: false,
               failure: { [weak self] error in
            guard let self, let error else { return }
            coordinator?.dismissViewController()
            authHelper.errorObserver.send(error.message.unwrap)
            phoneField.errorMessage(error.message.unwrap)
        })
    }
    
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    
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
            make.top.greaterThanOrEqualTo(phoneField.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(inset)
        }
            
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
                
    }
    
    private func checkButtonState() {
        phoneField.isValidated() ? acceptButton.enableButton() : acceptButton.disableButton()
    }
}
