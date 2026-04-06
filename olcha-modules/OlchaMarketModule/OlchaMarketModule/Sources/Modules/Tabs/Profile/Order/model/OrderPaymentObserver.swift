//
//  OrderPaymentObserver.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/10/22.
//

import Foundation
import OlchaUtils
import Combine
import OlchaBankCards
class OrderPaymentObserver {
    enum PaymentType: Equatable {
        case balance
        case payment(payment: Payments?)
        case card(card: BankCard)
        case `default`
    }
    
    var selectedPayment: PaymentType = .default
    let isSelected = PassthroughSubject<Bool, Never>()
    let tableReloader = PassthroughSubject<Bool, Never>()
    let balanceFill = PassthroughSubject<Void, Never>()
    
    var payment: String = ""
    var nextPayment: String = ""
    var totalPayment: String = ""
    
    
    
}
