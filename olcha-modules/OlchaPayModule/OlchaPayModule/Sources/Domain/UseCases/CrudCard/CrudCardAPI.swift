//
//  AddCardAPI.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 17/03/23.
//

import Foundation
import OlchaCore
public enum CrudCardAPI {
    case addCardOTP(model: AddCardOTPRequest)
    case verifyOTP(model: VerifyCardOTPRequest)
    case remove(id: Int)
    case update(id: Int, model: UpdateCardRequest)
}

extension CrudCardAPI: BaseOlchaPayApi {
    public var path: String {
        switch self {
            case .addCardOTP:
                return "bankcards/otp/"
            case .verifyOTP:
                return "bankcards/verify/"
            case .remove(let id):
                return "bankcards/\(id)/"
            case .update(let id, _):
                return "bankcards/\(id)/"
        }
    }
    
    public var method: RequestType {
        switch self {
            case .addCardOTP:
                return .post
            case .verifyOTP:
                return .post
            case .remove:
                return .delete
            case .update:
                return .put
        }
    }
    
    public var body: Data? {
        var data: Data?

        switch self {
            case .addCardOTP(let model):
                data = encode(model)
                break
            case .verifyOTP(let model):
                data = encode(model)
                break
            case .update(_, let model):
                data = encode(model)
                break
            default:
                break
        }
        
        return data
    }
    

}

