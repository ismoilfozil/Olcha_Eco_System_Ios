//
//  LoyaltyModel.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 21/07/24.
//

import UIKit
public struct LoyaltyModel {
    
    func getTitle() -> String {
        return "Tanish"
    }
    
    func getCashback() -> Double {
        return 1
    }
    
    func getSale() -> Double {
        return 20
    }
    
    func getColor() -> UIColor? {
        return .hex("FFA981")
    }
    
    func getImage() -> UIImage? {
        return .loyalty_1
    }
}
