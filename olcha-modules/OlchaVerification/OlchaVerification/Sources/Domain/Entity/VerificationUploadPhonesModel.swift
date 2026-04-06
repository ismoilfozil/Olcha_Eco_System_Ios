//
//  VerificationPhonesModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/09/22.
//

import Foundation
public struct VerificationUploadPhonesModel: Codable {
    let phones: [[String: String]]
}

public struct VerificationPhonesModel: Codable {
    var message: String?
    var data: [String: PhoneModel?]?
    var status: String?
    
    private enum CodingKeys: String, CodingKey {
        case message
        case data
        case status
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            message = try container.decode(String?.self, forKey: .message)
        } catch {}
        
        do {
            status = try container.decode(String?.self, forKey: .status)
        } catch {}
        do {
            data = try container.decode([String: PhoneModel?]?.self, forKey: .data)
        } catch {}
    }
}

public struct PhoneModel: Codable {
    public var phone: String?
    public var main: Bool?
    public var type: String?
}
