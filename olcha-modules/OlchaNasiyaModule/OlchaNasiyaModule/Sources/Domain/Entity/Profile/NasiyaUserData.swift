//
//  NasiyaUserData.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 23/05/23.
//

import Foundation
public struct NasiyaUserData: Codable {
    public var profile: NasiyaUser?
    
    public static func mock() -> NasiyaUserData {
        return NasiyaUserData(profile: .mock())
    }
}

public class NasiyaUser: Codable {
    public var id: Int?
    public var name: String?
    public var lastname: String?
    public var phone: String?
    public var extra_phone: String?
    public var passport: String?
    public var birthdate: String?
    public var mail: String?
    public var address: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case lastname
        case phone
        case extra_phone
        case passport
        case birthdate
        case mail
        case address
    }
    
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        } catch {}
        
        do {
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
            
        } catch {}
        do {
            self.lastname = try container.decodeIfPresent(String.self, forKey: .lastname)
            
        } catch {}
        do {
            self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
            
        } catch {}
        do {
            self.extra_phone = try container.decodeIfPresent(String.self, forKey: .extra_phone)
            
        } catch {}
        do {
            self.passport = try container.decodeIfPresent(String.self, forKey: .passport)
            
        } catch {}
        do {
            self.birthdate = try container.decodeIfPresent(String.self, forKey: .birthdate)
            
        } catch {}
        do {
            self.mail = try container.decodeIfPresent(String.self, forKey: .mail)
            
        } catch {}
        do {
            self.address = try container.decodeIfPresent(String.self, forKey: .address)
            
        } catch {}
    }
    
    public required init(instance: NasiyaUser) {
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
    
    public static func mock() -> NasiyaUser {
        return NasiyaUser()
    }
}
