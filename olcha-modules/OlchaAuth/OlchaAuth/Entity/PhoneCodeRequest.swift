//
//  PhoneCodeRequest.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 12/04/23.
//

import Foundation
public protocol PhoneCodeProtocol: Codable {
    
}

public struct PhoneCodeRequest: PhoneCodeProtocol {
    let phone: String
    let code: String
}

public struct PhoneCodeReferalRequest: PhoneCodeProtocol {
    let phone: String
    let code: String
    let referral_id: String?
}
