//
//  TField+Getter.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 10/04/23.
//

import UIKit
public extension TField {
    func getPhone() -> String {
        "998" + getText().phoneNumber
    }
    
    func getShortPhone() -> String {
        getText().phoneNumber
    }
    
    func getMobilePhone() -> String {
        getText().phoneNumber
    }
    
    func getText() -> String {
        settings.text ?? ""
    }
    
    func getPrice() -> String {
        (settings.text ?? "").replacingOccurrences(of: " ", with: "")
    }
    
    func getCardNumber() -> String {
        (settings.text ?? "").replacingOccurrences(of: " ", with: "")
    }
    
    func getCardExpire() -> String {
        (settings.text ?? "").phoneNumber
    }
 
    func getValue() -> String {
        switch  type {
        case .fullPhone:
            return getPhone()
        case .shortPhone:
            return getShortPhone()
        case .mobilePhone:
            return getMobilePhone()
        case .amount, .amountRanged, .amountMaxRange, .amountWithoutRange:
            return getPrice()
        case .cardNumber:
            return getCardNumber()
        case .cardExpire:
            return getCardExpire()
        default:
            return settings.text ?? ""
        }
    }
}
