//
//  EditNameModalPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 23/09/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaAuth
public class EditNameModalPage: BaseModalViewController {

    private let nameField: TField = {
        let field = TField()
        field.topHint = "name".localized()
        field.placeholder = "Elbek"
        return field
    }()
    private lazy var lastnameField: TField = {
        let field = TField()
        field.topHint = "lastname".localized()
        field.placeholder = "Hasanov"
        return field
    }()
    
    private lazy var acceptButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("save".localized())
        button.configure(type: .pay)
        return button
    }()
    
    public weak var userUpdateObserver: PassthroughSubject<Bool, Never>?
    public weak var user: User? {
        didSet {
            nameField.text = user?.name
            lastnameField.text = user?.lastname
        }
    }
    
    public override func setupViews() {
        container.addSubview(nameField)
        container.addSubview(lastnameField)
        container.addSubview(acceptButton)
    }
    
    public override func autolayout() {
        nameField.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        lastnameField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(nameField.snp.bottom).inset(-16)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(lastnameField.snp.bottom).inset(-16)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        setHeader(title: "edit_name".localized())
        dismissConfiguration()
    }
    
    public override func setupObservers() {
        acceptButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.user?.name = self.nameField.getText()
            self.user?.lastname = self.lastnameField.getText()
            self.userUpdateObserver?.send(true)
            self.dismiss(animated: true, completion: nil)
        }
    }
   
}
