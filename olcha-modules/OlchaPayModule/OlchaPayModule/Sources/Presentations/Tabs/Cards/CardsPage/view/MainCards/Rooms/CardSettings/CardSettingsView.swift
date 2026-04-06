//
//  CardSettingsView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/02/23.
//

import Foundation
import OlchaUI
import UIKit
public class CardSettingsView: BaseView {
    
    public lazy var header: GroupHeaderView = {
        let view = GroupHeaderView()
        view.seeAllHidden = true
        return view
    }()
    
    public lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    public let cardColor = CardColorView()
    public let cardMakeDefault = CardMakeDefaultView()
    public let cardName = CardNameView()
    
    public override func setupViews() {
        addSubview(header)
        addSubview(stack)
        stack.addArrangedSubview(cardColor)
        stack.addArrangedSubview(cardMakeDefault)
        stack.addArrangedSubview(cardName)
    }
    
    public override func autolayout() {
        header.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(16)
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        cardColor.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        cardMakeDefault.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        cardName.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
    }
    
    public func setup(with card: UserBankCardModel) {
        header.set(title: "card_settings".localized())
        cardColor.setup(color: card.color)
        cardMakeDefault.setup(isDefault: card.isDefault)
        cardName.setup(name: card.cardName)
    }
}
