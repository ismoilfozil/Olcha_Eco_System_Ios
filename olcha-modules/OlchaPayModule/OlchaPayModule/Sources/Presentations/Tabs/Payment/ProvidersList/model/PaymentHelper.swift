//
//  File.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 21/02/23.
//

import Foundation
import Combine
public class PushPaymentHelper {
    
    public let pushPayment = PassthroughSubject<Bool, Never>()
    public let pushPaymentDetail = PassthroughSubject<TransactionModel?, Never>()
    public let pushPaymentMonitoring = PassthroughSubject<Bool, Never>()
    
}
