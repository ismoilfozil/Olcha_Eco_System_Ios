//
//  NasiyaUserData.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 23/05/23.
//

import Foundation
import OlchaUtils
public struct InvestUserData: Codable {
    public var data: InvestUser?
    
    public static func mock() -> InvestUserData {
        return InvestUserData(data: .mock())
    }
}

public class InvestUser: Codable, Copying {
    public var id: Int?
    public var name: String?
    public var lastname: String?
    public var phone: String?
    public var extra_phone: String?
    public var passport: String?
    public var birthdate: String?
    public var mail: String?
    public var address: String?
    
    public required init(instance: InvestUser) {
        id = instance.id
        name = instance.name
        lastname = instance.lastname
        phone = instance.phone
        extra_phone = instance.extra_phone
        passport = instance.passport
        birthdate = instance.birthdate
        mail = instance.mail
        address = instance.address
    }
    
    public init() {}
    
    public static func mock() -> InvestUser {
        return InvestUser()
    }
}
