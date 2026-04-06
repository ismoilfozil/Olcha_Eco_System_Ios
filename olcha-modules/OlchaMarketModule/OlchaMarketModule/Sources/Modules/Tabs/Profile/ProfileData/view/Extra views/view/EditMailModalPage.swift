//
//  EditMailModalPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 23/09/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaAuth
class EditMailModalPage: BaseViewController {

    private let mailField = TField()
    private let acceptButton = OlchaButton()
    
    weak var userUpdateObserver: PassthroughSubject<Bool, Never>?
    weak var user: User? {
        didSet {
            mailField.text = user?.email
        }
    }
    
    override func viewDidLoad() {
        setupModalViews()
        modalAutolayout()
        configureModalViews(header: "edit_email".localized(), textAlignment: .left)
        setupObservers()
    }
    
    override func setupModalViews() {
        super.setupModalViews()
        modalContainer.addSubview(mailField)
        modalContainer.addSubview(acceptButton)
    }
    
    override func modalAutolayout() {
        super.modalAutolayout()
        mailField.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(16)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.top.equalTo(mailField.snp.bottom).inset(-16)
            make.height.equalTo(40)
            make.left.bottom.right.equalToSuperview().inset(16)
        }
    }
    
    override func configureModalViews(header: String = "", textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: header, textAlignment: textAlignment)
        
        mailField.topHint = "mail".localized()
        acceptButton.setTitle("save".localized())
    }
    
    override func setupObservers() {
        acceptButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.user?.email = self.mailField.getText()
            self.userUpdateObserver?.send(true)
            self.dismiss(animated: true, completion: nil)
        }
    }

}
