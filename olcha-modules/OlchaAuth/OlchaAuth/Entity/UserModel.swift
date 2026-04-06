//
//  UserModel.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 28/04/23.
//

import Foundation
public struct UserModel : Codable {
    public var message: String?
    public var status: String?
    public var data: UserData?
}
public struct UserData : Codable {
    public var user: User?
}

public class User : Codable {
    public var id: Int?
    public var name: String?
    public var lastname: String?
    public var activate: Int?
    public var blocked: Int?
    public var gender: Int?
    public var birthdate: String?
    public var is_verified: Int?
    public var phone: String?
    public var balance: Int?
    public var email: String?
    public var created_at: String?
    
    public init(id: Int?,
                name: String?,
                lastname: String?,
                activate: Int?,
                blocked: Int?,
                gender: Int?,
                birthdate: String?,
                is_verified: Int?,
                phone: String?,
                balance: Int? = nil,
                email: String? = nil,
                created_at: String? = nil) {
        self.id = id
        self.name = name
        self.lastname = lastname
        self.activate = activate
        self.blocked = blocked
        self.gender = gender
        self.birthdate = birthdate
        self.is_verified = is_verified
        self.phone = phone
        self.balance = balance
        self.email = email
        self.created_at = created_at
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do { self.id = try container.decodeIfPresent(Int.self, forKey: .id) } catch {}
        do { self.name = try container.decodeIfPresent(String.self, forKey: .name) } catch {}
        do { self.lastname = try container.decodeIfPresent(String.self, forKey: .lastname) } catch {}
        do { self.activate = try container.decodeIfPresent(Int.self, forKey: .activate) } catch {}
        do { self.blocked = try container.decodeIfPresent(Int.self, forKey: .blocked) } catch {}
        do { self.gender = try container.decodeIfPresent(Int.self, forKey: .gender) } catch {}
        do { self.birthdate = try container.decodeIfPresent(String.self, forKey: .birthdate) } catch {}
        do { self.is_verified = try container.decodeIfPresent(Int.self, forKey: .is_verified) } catch {}
        do { self.phone = try container.decodeIfPresent(String.self, forKey: .phone) } catch {}
        do { self.balance = try container.decodeIfPresent(Int.self, forKey: .balance) } catch {}
        do { self.email = try container.decodeIfPresent(String.self, forKey: .email) } catch {}
        do { self.created_at = try container.decodeIfPresent(String.self, forKey: .created_at) } catch {}
    }
    
    public init() {
        
    }
    
    public init(name: String?, lastname: String?) {
        self.name = name
        self.lastname = lastname
    }
    
    public func getEditUser() -> EditUserProtocol {
        if (birthdate ?? "").isEmpty {
            return EditUserNoBirthdate(name: name ?? "",
                                       lastname: lastname ?? "",
                                       email: email ?? "")
            
        } else {
            return EditUser(name: name ?? "",
                            lastname: lastname ?? "",
                            birthdate: birthdate ?? "",
                            email: email ?? "")
            
        }
    }
    
    public func getFullname() -> String {
        (name ?? "") + " " + (lastname ?? "")
    }
    
    public func getVerified() -> Bool {
        is_verified.orZero == 0 ? false : true
    }
}

public protocol EditUserProtocol: Codable {
    
}

public class EditUser : EditUserProtocol {
    public let name: String
    public let lastname: String
    public let birthdate: String
    public let email: String
    
    public init(name: String, lastname: String, birthdate: String, email: String) {
        self.name = name
        self.lastname = lastname
        self.birthdate = birthdate
        self.email = email
    }
}

public class EditUserNoBirthdate : EditUserProtocol {
    let name: String
    let lastname: String
    let email: String
    
    public init(name: String, lastname: String, email: String) {
        self.name = name
        self.lastname = lastname
        self.email = email
    }
}
