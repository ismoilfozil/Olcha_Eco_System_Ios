//
//  CardNameModalViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 06/02/23.
//

import UIKit
import OlchaUI
public class CardNameModalViewController: BaseModalViewController {
    
    
    
    public lazy var nameField: TField = {
        let field = TField()
        field.topHint = "named".localized()
        return field
    }()
    
    public lazy var saveButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("save".localized())
        return button
    }()
    
    
    public weak var observers: CardSettingsObserver?
    public weak var card: UserBankCardModel?
    
    public override func setupViews() {
        container.addSubview(saveButton)
        container.addSubview(nameField)
    }
    
    public override func autolayout() {
        nameField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).inset(-39)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    public override func configureViews() {
        dismissConfiguration()
        setHeader(title: "card_name".localized())
    }
    
    public override func setupObservers() {
        saveButton.clicked { [weak self] in
            guard let self = self else { return }
            self.card?.cardName = self.nameField.getText()
            self.observers?.cardUpdated.send(self.card)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    public override func initialRequest() {
        nameField.text = self.card?.cardName ?? ""
    }
}
