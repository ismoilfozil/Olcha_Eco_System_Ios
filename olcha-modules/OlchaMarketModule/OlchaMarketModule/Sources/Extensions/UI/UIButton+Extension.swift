//
//  UIButton+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//


import UIKit
extension UIButton {
    
    func designButton(color: UIColor?,
                      title: String) {
        self.round(8)
        self.setTitleColor(.olchaWhite, for: .normal)
        self.setTitleColor(.olchaWhite, for: .highlighted)
        self.backgroundColor = color
        self.titleLabel?.style(.medium, 14)
        self.setTitle(title, for: .normal)
    }
    
    func designButton(with icon: UIImage? = nil,
                      accentColor: UIColor? = .olchaTextBlack) {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 2
        self.layer.borderColor = accentColor?.cgColor
        self.setTitleColor(accentColor, for: .normal)
        
        self.backgroundColor = .clear
        self.titleLabel?.style(.medium, 14)
        if let icon = icon {
            self.setImage(icon, for: .normal)
            self.setImage(icon, for: .highlighted)
            self.setImage(UIImage(), for: .disabled)
        }
    }
    
    func designSeeAll() {
        self.setTitle(MarketTexts.seeAll, for: .normal)
        self.setTitleColor(.olchaAccentColor, for: .normal)
    }
    
    func designAccentButtons(_ title: String, withShadow: Bool = true) {
        self.round()
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .style(.medium, 16)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .olchaAccentColor
        if withShadow {
            self.shadowAdd()
        }
        
    }
}
