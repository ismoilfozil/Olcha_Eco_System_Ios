//
//  CartBonusRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/02/23.
//

import UIKit
import OlchaUI
class CartBonusRoom: BaseTableCell {

    let textField = TField()
    
    weak var observers: CartObservers?
    
    override func setupViews() {
        container.addSubview(textField)
    }
    
    override func autolayout() {
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.top.equalToSuperview()
//            make.height.equalTo(100)
        }
    }
    
    override func configureViews() {
        textField.type = .amount
        textField.topHint = "bonus".localized()
        textField.bottomHintLabel.textColor = .olchaAccentColor
        textField.observeText { [weak self] in
            guard let self = self else { return }
            
            if self.textField.getPrice().double > (self.observers?.bonus?.getMaximumBonus().double ?? 0) {
                self.textField.settings.text = (self.observers?.bonus?.getMaximumBonus().string ?? "0").priceWithoutCurrency
            }
            
            self.observers?.bonus?.usingBonus = self.textField.getPrice()
        }
        
        textField.settings.addTarget(self,
                                     action: #selector( editingFinished(_:) ),
                                     for: .editingDidEnd)
        
    }
    
    @objc func editingFinished(_ sender: UITextField) {
        observers?.action.loadGetCost.send()
    }
    
    func setup() {
        textField.text = (observers?.bonus?.usingBonus ?? "0").priceWithoutCurrency
        if (observers?.bonus?.checkMaximumBonus() ?? false) {
            textField.bottomHint = "max_bonus".localized() + " " + (observers?.bonus?.bonus_rule?.string.price ?? "")
        } else {
            textField.bottomHint = " "
        }
    }
 
}
class CartBonusRoomView: BaseTableCellView {

    let textField = TField()
    
    weak var observers: CartObservers?
    
    override func setupViews() {
        container.addSubview(textField)
    }
    
    override func autolayout() {
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.top.equalToSuperview()
//            make.height.equalTo(100)
        }
    }
    
    override func configureViews() {
        textField.type = .amount
        textField.topHint = "bonus".localized()
        textField.bottomHintLabel.textColor = .olchaAccentColor
        textField.observeText { [weak self] in
            guard let self = self else { return }
            
            if self.textField.getPrice().double > (self.observers?.bonus?.getMaximumBonus().double ?? 0) {
                self.textField.settings.text = (self.observers?.bonus?.getMaximumBonus().string ?? "0").priceWithoutCurrency
            }
            
            self.observers?.bonus?.usingBonus = self.textField.getPrice()
        }
        
        textField.settings.addTarget(self,
                                     action: #selector( editingFinished(_:) ),
                                     for: .editingDidEnd)
        
    }
    
    @objc func editingFinished(_ sender: UITextField) {
        observers?.action.loadGetCost.send()
    }
    
    func setup() {
        textField.text = (observers?.bonus?.usingBonus ?? "0").priceWithoutCurrency
        if (observers?.bonus?.checkMaximumBonus() ?? false) {
            textField.bottomHint = "max_bonus".localized() + " " + (observers?.bonus?.bonus_rule?.string.price ?? "")
        } else {
            textField.bottomHint = " "
        }
    }
 
}
