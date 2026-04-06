//
//  CartActionsRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/10/22.
//

import UIKit
import Combine
import OlchaUI
class CartActionsRoom: BaseTableCell {
    
    weak var pushOffer: PassthroughSubject<Void, Never>?
    
    let acceptButton = OlchaButton()
    
    let privacyButton = UILabel()
    
    var buttonState: Bool = false {
        didSet {
            buttonState ? acceptButton.enableButton() : acceptButton.disableButton()
        }
    }
    
    override func setupViews() {
        container.addSubview(privacyButton)
        container.addSubview(acceptButton)
    }
    
    override func autolayout() {
        acceptButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        privacyButton.snp.makeConstraints { make in
            make.bottom.equalTo(acceptButton.snp.top).inset(-8)
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
    }
    
    override func configureViews() {}
    
    func setup() {
        acceptButton.setTitle("checkout_order".localized())
        
        let privacyText = "checkout_oferta".localized()
        let textAttributes:[NSAttributedString.Key : Any] = [
            .font: UIFont.style(.medium, 12),
            .foregroundColor: UIColor.olchaLightTextColornnnnnn]
        
        
        let rangeText = "profile_oferta_subtitle2".localized()
        let rangeTextAttributes:[NSAttributedString.Key : Any] = [
            .font: UIFont.style(.medium, 12),
            .foregroundColor: UIColor.olchaAccentColor]
        privacyButton.numberOfLines = 0
        privacyButton.textAlignment = .center
        
        privacyButton.addTapGesture(
            text: privacyText,
            textAttributes: textAttributes,
            tapOnText: rangeText,
            tapOnTextAttributes: rangeTextAttributes) { [weak self] in
                guard let self = self else { return }
                self.pushOffer?.send()
        }
    }
    
}
