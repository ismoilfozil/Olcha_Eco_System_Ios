//
//  BalasnsFillPage+Models.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/11/22.
//

import Foundation
import OlchaUtils

extension BalanceFillPage {
    public enum Section {
        case card
        case payments
    }
    
    public class Observer {
        public enum PaymentType: Equatable {
            case payment(payment: Payments?)
            case card
            case none
        }
        
        public var selectedPayment: PaymentType = .none
    }
}
