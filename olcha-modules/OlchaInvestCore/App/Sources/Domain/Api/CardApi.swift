//
//  CardApi.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 07/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
import OlchaCore

public enum CardApi {
    case sendOtp(card: CardSendOtpRequest)
    case confirmOtp(card: CardConfirmOtpRequest)
    case cards
}

extension CardApi: InvestBaseApi {
    public var path: String {
        switch self {
        case .sendOtp:
            return "myuzcard/send-otp"
        case .confirmOtp:
            return "myuzcard/confirm-otp"
        case .cards:
            return "myuzcard/cards"
        }
    }
    
    public var queryItems: [URLQueryItem] {
        return []
    }
    
    public var method: RequestType {
        switch self {
        case .sendOtp, .confirmOtp:
            return .post
        case .cards:
            return .get
        }
    }
    
    public var body: Data? {
        switch self {
        case .sendOtp(let sendOtpModel):
            return try? JSONEncoder().encode(sendOtpModel)
        case .confirmOtp(let confirmModel):
            return try? JSONEncoder().encode(confirmModel)
        case .cards:
            return nil
        }
    }
}
