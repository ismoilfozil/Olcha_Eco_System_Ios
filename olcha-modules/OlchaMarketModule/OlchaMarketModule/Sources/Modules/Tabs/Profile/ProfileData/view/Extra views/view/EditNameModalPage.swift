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
class EditNameModalPage: BaseViewController {

    private let nameField = TField()
    private let lastnameField = TField()
    private let acceptButton = OlchaButton()
    
    weak var userUpdateObserver: PassthroughSubject<Bool, Never>?
    weak var user: User? {
        didSet {
            nameField.text = user?.name
            lastnameField.text = user?.lastname
        }
    }
    
    override func viewDidLoad() {
        setupModalViews()
        modalAutolayout()
        configureModalViews(header: "edit_name".localized(), textAlignment: .left)
        setupObservers()
    }
    
    override func setupModalViews() {
        super.setupModalViews()
        modalContainer.addSubview(nameField)
        modalContainer.addSubview(lastnameField)
        modalContainer.addSubview(acceptButton)
    }
    
    override func modalAutolayout() {
        super.modalAutolayout()
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
    
    override func configureModalViews(header: String = "", textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: header, textAlignment: textAlignment)
        dismissConfiguration()
        nameField.topHint = "name".localized()
        nameField.placeholder = "Elbek"
        
        lastnameField.topHint = "lastname".localized()
        lastnameField.placeholder = "Hasanov"
        
        acceptButton.setTitle("save".localized())
    }
    
    override func setupObservers() {
        acceptButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.user?.name = self.nameField.getText()
            self.user?.lastname = self.lastnameField.getText()
            self.userUpdateObserver?.send(true)
            self.dismiss(animated: true, completion: nil)
        }
    }
   
}
