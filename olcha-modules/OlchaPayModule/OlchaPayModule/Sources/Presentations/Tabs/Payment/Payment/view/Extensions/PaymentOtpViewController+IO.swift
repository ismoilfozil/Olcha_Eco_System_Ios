//
//  PaymentOtpViewController+IO.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 09/11/23.
//

import Foundation
extension PaymentOtpViewController {
    public struct Input {
        public var verifyOtpData: TransactionOtpData?
        public weak var paymentHelper: MakePaymentHelper?
        
        public init() {}
    }
}
