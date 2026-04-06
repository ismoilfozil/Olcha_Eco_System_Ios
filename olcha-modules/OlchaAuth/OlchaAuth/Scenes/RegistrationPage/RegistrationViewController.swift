//
//  RegistrationPage.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 24/02/23.
//

import UIKit
import OlchaUI

public protocol RegistrationViewControllerProtocol: UIViewController {
    var coordinator: AuthCoordinatorProtocol? { get set }
    var viewModel: AuthViewModel { get set }
    var authCompletion: (() -> Void)? { get set }
}
public class RegistrationViewController: BaseViewController<BackNavigationBar>, RegistrationViewControllerProtocol {
    
    private let scrollView: IScrollView = {
        let scrollView = IScrollView()
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.bold, 24)
        label.textColor = .olchaTextBlack
        label.text = "register".localized()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var fieldStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
//    private let nameField: TField = {
//        let field = TField()
//        field.topHint = "name".localized()
//        return field
//    }()
//
//    private let lastnameField: TField = {
//        let field = TField()
//        field.topHint = "lastname".localized()
//        return field
//    }()
    
    private let passwordField: TField = {
        let field = TField()
        field.topHint = "password".localized()
        field.type = .password
        field.field_tag = (\PasswordEditRequest.password).propertyName
        return field
    }()
    
    private let password2Field: TField = {
        let field = TField()
        field.topHint = "retry_new_password".localized()
        field.type = .password
        field.field_tag = (\PasswordEditRequest.password_confirmation).propertyName
        return field
    }()
    
    private let acceptButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("register".localized())
        button.configure(type: .pay)
        return button
    }()
    
    public var viewModel: AuthViewModel

    public weak var coordinator: AuthCoordinatorProtocol?
    
    public var authCompletion: (() -> Void)?
    
    public override var validatedFields: [TField] {
        [passwordField, password2Field]
    }
    
    public init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        
        scrollView.scrollContainer.addSubview(titleLabel)
        scrollView.scrollContainer.addSubview(fieldStack)
//        fieldStack.addArrangedSubview(nameField)
//        fieldStack.addArrangedSubview(lastnameField)
        fieldStack.addArrangedSubview(passwordField)
        fieldStack.addArrangedSubview(password2Field)
        scrollView.scrollContainer.addSubview(acceptButton)
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.bottom.top.left.right.equalToSuperview()
        }
        
        scrollView.scrollContainer.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(container.snp.height).priority(.low)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(110)
        }
        
        fieldStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(fieldStack.snp.bottom)
            make.bottom.left.right.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        checkButtonState()
    }
    
    public override func setupObservers() {
        
        passwordField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkButtonState()
        }
        
        password2Field.observeText { [weak self] in
            guard let self = self else { return }
            self.checkButtonState()
        }
        
        acceptButton.settings.clicked { [weak self] in
            guard let self = self,
                  let phone = self.coordinator?.phone else { return }
            self.viewModel.editPassword(phone: phone,
                                        password: self.passwordField.getValue(),
                                        password2: self.password2Field.getValue())
        }
        
        handle(viewModel.$editPasswordPublisher, success: { [weak self] data in
            guard let self = self, data != nil else { return }
//            self.coordinator?.finishAuth()
            self.authCompletion?()
        }, loading: { [weak self] isLoading in
            guard let self = self else { return }
            self.acceptButton.settings.requesting = isLoading
        })

    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func checkButtonState() {
        if passwordField.isValidated() && password2Field.isValidated() {
            acceptButton.enableButton()
        } else {
            acceptButton.disableButton()
        }
    }
}
