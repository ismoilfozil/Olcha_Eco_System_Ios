//
//  AnorbankAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/11/22.
//

import Foundation
import OlchaCore
import OlchaUtils
enum AnorbankAPI {
    case sendOTP(model: AddAnorbankRequest)
    case verifyOTP(model: VerifyAnorbankRequest)
}

extension AnorbankAPI: OlchaMarketAPI {
   
    var version: String {
        switch self {
            default: return Texts.url.getVersion(3)
        }
    }
    
    var path: String {
        switch self {
            case .sendOTP:
                return "instalment-payment/anorbank/send-otp"
            case .verifyOTP:
                return "instalment-payment/anorbank/verify-otp"
        }
    }
    
    var method: RequestType {
        switch self {
        case .sendOTP:
            return .post
        case .verifyOTP:
            return .post
        }
    }
    
    var body: Data? {
        var data: Data?
        
        switch self {
        case .sendOTP(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
        case .verifyOTP(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
        }
        return data
    }
    
    
}
