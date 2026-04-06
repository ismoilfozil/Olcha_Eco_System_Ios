//
//  ProfileDataViewController.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 22/05/23.
//

import OlchaAuth
import UIKit
import OlchaUI
public class ProfileDataViewController: BaseViewController<BackNavigationBar> {
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.container.spacing = 16
        
        return scrollView
    }()
    
    private let actionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    public let editButton: IButton = {
        let button = IButton()
        button.backgroundColor = .olchaLightNeutralDarkGray
        button.round(10)
        button.setTitleColor(.olchaTextBlack, for: .normal)
        button.titleLabel?.style(.semibold, 16)
        return button
    }()
    
    public let saveButton: NasiyaButton = {
        let button = NasiyaButton()
        return button
    }()
    
    public let cancelButton: IButton = {
        let button = IButton()
        button.backgroundColor = .clear
        button.setTitleColor(.olchaTextBlack, for: .normal)
        button.titleLabel?.style(.semibold, 16)
        return button
    }()
    
    public var editingMode: Bool = false {
        didSet {
            stateChanged()
        }
    }
    
    private var datePicker: UDatePicker?
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    public var input: Input
    public var output: Output
    
    public let viewModel: ProfileViewModel
    
    public init(viewModel: ProfileViewModel,
                input: Input = .init(),
                output: Output = .init()) {
        self.viewModel = viewModel
        self.input = input
        self.output = output
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var validatedFields: [TField] {
        output.factory.allFields
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        container.addSubview(actionsStackView)
        createFields()
        createButtons()
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
        actionsStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).inset(-8)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
        
        scrollView.horizontalEdge(16)
    }
    
    public override func configureViews() {
        languageUpdated()
    }
    
    public override func setupObservers() {
        editButton.clicked { [weak self] in
            guard let self = self else { return }
            editingMode = true
            output.copyUser()
        }
        
        saveButton.clicked { [weak self] in
            guard let self = self else { return }
            editingMode = false
            fillEditingUser()
            output.saveUser()
            saveUser()
        }
        
        cancelButton.clicked { [weak self] in
            guard let self = self else { return }
            editingMode = false
            output.removeEditingUser()
            fillFields()
        }
        
        output.factory.birthdateField.button.clicked { [weak self] in
            guard let self = self else { return }
            datePicker = presentDatePicker(datePicker: datePicker) { date in
                self.output.factory.birthdateField.settings.text = date
                self.output.factory.birthdateField.isValidated(withMessage: true)
                self.checkButtonState()
            }
        }
        
        output.factory.allFields.forEach { [weak self] in
            guard let self = self else { return }
            $0.observeText {
                self.checkButtonState()
            }
        }
        
        handle(viewModel.$editUser,
               loading: { [weak self] isLoading in
            guard let self = self else { return }
            saveButton.settings.requesting = isLoading
        })
        
        handle(viewModel.$user, success: { [weak self] data in
            guard let self = self else { return }
            output.userModel = data
            fillFields()
        })

    }
    
    public override func initialRequest() {
        editingMode = false
        viewModel.loadUserData()
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("profile".localized())
        editButton.setTitle("edit".localized(), for: .normal)
        saveButton.setTitle("save".localized())
        cancelButton.setTitle("cancel".localized(), for: .normal)
    }
    
    public func createFields() {
        scrollView.container.arrangedSubviews.forEach { $0.removeFromSuperview() }
        output.factory.allSubviews.forEach {
            scrollView.addArrangedSubview($0)
            $0.snp.makeConstraints { make in make.left.right.equalToSuperview() }
        }
    }
    
    public func createButtons() {
        actionsStackView.addArrangedSubview(editButton)
        actionsStackView.addArrangedSubview(saveButton)
        actionsStackView.addArrangedSubview(cancelButton)
        
        [
            editButton,
            cancelButton,
            saveButton
        ].forEach {
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(40)
            }
        }
    }
    
    public func saveUser() {
        viewModel.edit(user: output.userModel)
    }
    
    private func checkButtonState() {
        var isEnabled = true
        
        if !output.factory.nameField.isValidated() {
            isEnabled = false
        }
        
        isEnabled ? saveButton.enableButton() : saveButton.disableButton()
    }
}
