//
//  WelcomePage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/09/22.
//

import UIKit
import Combine
import IQKeyboardManagerSwift
import OlchaUI
public protocol WelcomePageProtocol: UIViewController {
    var coordinator: AuthCoordinatorProtocol? { get set }
    var canDismiss: Bool { get set }
    var viewModel: AuthViewModel { get set }
    
    var loginObserver: (() -> Void)? { get set }
    var pushRegistrationObserver: (() -> Void)? { get set }
    var pushConfirmCode: ((ConfirmCodeHelper) -> Void)? { get set }
}
open class WelcomePage: BaseViewController<BackNavigationBar>, WelcomePageProtocol {

    public let phoneTitle = UILabel()
    
    public let phoneField = TField()
    
    private let acceptButton = OlchaButton()
    
    public weak var coordinator: AuthCoordinatorProtocol?
    
    public let authHelper = ConfirmCodeHelper()
    
    public var viewModel: AuthViewModel
    
    public var canDismiss: Bool = false {
        didSet {
            navigationBar.backButton.isHidden = !canDismiss
        }
    }
    
    public var loginObserver: (() -> Void)?
    
    public var pushRegistrationObserver: (() -> Void)?
    
    public var pushConfirmCode: ((ConfirmCodeHelper) -> Void)?
    
    open override var validatedFields: [TField] {
        [phoneField]
    }
    
    public init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(phoneTitle)
        container.addSubview(phoneField)
        container.addSubview(acceptButton)
    }
    
    public override func autolayout() {
        phoneTitle.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().inset(110)
            make.left.right.equalToSuperview().inset(16)
        }
        
        phoneField.snp.makeConstraints { make in
            make.top.equalTo(phoneTitle.snp.bottom).inset(-24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    open override func configureViews() {
        phoneTitle.style(.bold, 24)
        phoneTitle.textColor = .olchaTextBlack
        phoneTitle.text = "welcome".localized()
        phoneTitle.textAlignment = .center
        
        phoneField.topHint = "phone_number".localized()
        phoneField.field_tag = "phone"
        phoneField.type = .shortPhone
        
        acceptButton.disableButton()
        acceptButton.setTitle("next".localized())
        checkButtonState()
    }
    
    public override func setupObservers() {
        
        phoneField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkButtonState()
        }
        
        acceptButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            IQKeyboardManager.shared.resignFirstResponder()
            self.checkPhone()
        }
        
        authHelper
            .sendCodeObserver
            .sink { [weak self] canSend in
                guard let self = self,
                      let phone = self.coordinator?.phone,
                      canSend else { return }
                self.viewModel.confirmCode(phone: phone)
            }.store(in: &bag)
        
        authHelper
            .codeConfirmObserver
            .sink { [weak self] code in
                guard let self = self,
                      let phone = self.coordinator?.phone,
                      code.count == 5 else { return }
                self.coordinator?.code = code
                self.viewModel.registerPhoneCode(phone: phone,
                                                 code: code)
            }.store(in: &bag)
        
        viewModelObservers()
    }
    
    private func viewModelObservers() {

        handle(viewModel.$isPhoneExists,
               success:  { [weak self] data in
            guard let self = self else { return }
            self.coordinator?.phone = self.phoneField.getPhone()
            if (data?.exists ?? false) {
                loginObserver?()
            } else {
                pushConfirmCode?(authHelper)
            }
        }, loading: { [weak self] isLoading in
            guard let self = self else { return }
            self.acceptButton.settings.requesting = isLoading
        })
        
        handle(viewModel.$sendConfirmCodePublisher,
               failure: { [weak self] error in
            guard let self = self else { return }
            self.showError(text: error?.message)
        })
        
        handle(viewModel.$registerPhoneCodePublisher) { [weak self] data in
            guard let self = self else { return }
            self.authHelper.dismissObserver.send(true)
            self.pushRegistrationObserver?()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.authHelper.errorObserver.send(error?.message ?? "")
            self.showError(text: error?.message)
        } loading: { [weak self] isLoading in
            guard let self = self else { return }
            self.authHelper.requestingObserver.send(isLoading)
        }
        
        navigationBar.backButton.clicked { [weak self] in
            guard let self else { return }
            coordinator?.closeAuth(shouldPresent: true)
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    
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
//MARK: - Networking
extension WelcomePage {
    func checkPhone() {
        viewModel.checkPhone(phoneField.getPhone())
    }
}
