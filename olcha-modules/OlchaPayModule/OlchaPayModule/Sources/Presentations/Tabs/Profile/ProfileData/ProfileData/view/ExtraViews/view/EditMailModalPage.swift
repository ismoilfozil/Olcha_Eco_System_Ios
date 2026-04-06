//
//  EditMailModalPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 23/09/22.
//

import UIKit
import OlchaUI
import Combine
import OlchaAuth
public class EditMailModalPage: BaseModalViewController {

    private lazy var mailField: TField = {
        let field = TField()
        field.topHint = "mail".localized()
        return field
    }()
    private lazy var acceptButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("save".localized())
        button.configure(type: .pay)
        return button
    }()
    
    weak var userUpdateObserver: PassthroughSubject<Bool, Never>?
    weak var user: User? {
        didSet {
            mailField.text = user?.email
        }
    }
    
    
    public override func setupViews() {
        container.addSubview(mailField)
        container.addSubview(acceptButton)
    }
    
    public override func autolayout() {
        mailField.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(16)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.top.equalTo(mailField.snp.bottom).inset(-16)
            make.height.equalTo(40)
            make.left.bottom.right.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        setHeader(title: "edit_email".localized())
    }
    
    public override func setupObservers() {
        acceptButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.user?.email = self.mailField.getText()
            self.userUpdateObserver?.send(true)
            self.dismiss(animated: true, completion: nil)
        }
    }

}
