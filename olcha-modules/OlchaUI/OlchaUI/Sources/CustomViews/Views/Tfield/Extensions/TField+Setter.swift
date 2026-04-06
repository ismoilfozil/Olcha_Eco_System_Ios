//
//  TField+Setter.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 10/04/23.
//

import UIKit
public extension TField {
    func setPhone(number: String?) {
        guard let number = number else { return }
        
        if number.starts(with: "998") {
            if number.count == "998901234567".count {
                settings.text = number[3..<number.count].formatPhoneNumber
            }
        } else {
            if number.count == "901234567".count {
                settings.text = number.formatPhoneNumber
            }
        }
    
        
    }
    
    func setMobilePhone(number: String?) {
        setPhone(number: number)
//        if let number = number {
//            if number.starts(with: "998"),
//               number.count == 12 {
//                settings.text = number.formatPhoneNumber
//            }
//        }

    }
    
    func setCard(number: String?) {
        settings.text = number?.makeReadableCardNumber
    }

    func setCard(expire: String?) {
        settings.text = expire?.makeReadableExpireDateForCard
    }
    
    func setAmount(text: String?) {
        settings.text = text?.originalPrice
    }

    func setValue(string: String?) {
        switch type {
        case .fullPhone:
            settings.text = string?.formatFullPhoneNumber
            break
        case .shortPhone:
            setPhone(number: string)
            break
        case .mobilePhone:
            setMobilePhone(number: string)
        case .amountRanged, .amountWithoutRange, .amount:
            settings.text = string?.originalPriceWithoutCurrency
            break
        case .cardNumber:
            setCard(number: string)
            break
        case .cardExpire:
            setCard(expire: string)
            break
        default:
            settings.text = string
            break
        }
        
        self.textFieldEditingChanged(self.settings)
    }
}
