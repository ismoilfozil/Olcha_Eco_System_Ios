//
//  ReceiverDataModalPage.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 06/02/24.
//

import UIKit
import OlchaUI
import OlchaAuth
class ReceiverDataModalPage: BaseModalViewController {
    
    private let nameField: LightField = {
        let field = LightField()
        field.placeholder = "name".localized()
        field.type = .required
        return field
    }()
    
    private let phoneField: LightField = {
        let field = LightField()
        field.type = .mobilePhone
        return field
    }()
    
    private let saveButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("save".localized())
        return button
    }()
    
    weak var coordinator: CartCoordinatorProtocol?
    
    weak var observers: CartObservers?
    
    override func setupViews() {
        container.addSubview(nameField)
        container.addSubview(phoneField)
        container.addSubview(saveButton)
    }
    
    override func autolayout() {
        nameField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
        }
        
        phoneField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(nameField.snp.bottom).inset(-18)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(phoneField.snp.bottom).inset(-50)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    override func configureViews() {
        setHeader(title: "receiver_order".localized())
        xButton.isHidden = true
    }
    
    override func setupObservers() {
        saveButton.clicked { [weak self] in
            guard let self else { return }
            observers?.name = nameField.getValue()
            observers?.phone = phoneField.getPhone()
            observers?.action.tableReloader.send()
            dismiss(animated: true)
        }
    }
    
    override func setupOptionalObservers() {
        nameField.setValue(string: observers?.name ?? AuthGlobalDefaults.user.name)
        phoneField.setValue(string: observers?.phone ?? AuthGlobalDefaults.user.phone)
    }
    
}
