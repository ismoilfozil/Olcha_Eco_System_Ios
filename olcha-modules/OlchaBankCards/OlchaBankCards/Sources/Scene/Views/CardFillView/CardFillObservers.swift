//
//  CardFillObservers.swift
//  OlchaBankCards
//
//  Created by ahrorxudja on 30/11/23.
//

import Foundation
import Combine

public class CardFillObservers {
    
    public init() {}
    
    public let stateObserver = PassthroughSubject<Bool, Never>()
    public let sendCodeObserver = PassthroughSubject<VerificationUploadCode, Never>()
    public let sendCardObserver = PassthroughSubject<VerificationUploadBankCard, Never>()
    public let codeSentObserver = PassthroughSubject<Bool, Never>()
    public let requestFinished = PassthroughSubject<Bool, Never>()
}
