//
//  LoginModel.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 12/04/23.
//


import Foundation
public struct LoginModel : Codable {
    public var access_token: String?
    public var expires_in: Int?
    public var refresh_token: String?
    public var token_type: String?
    public var message: String?
    public var status_code: String?
    
    private enum CodingKeys : String, CodingKey {
        case access_token
        case expires_in
        case refresh_token
        case token_type
        case message
        case status_code
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            access_token = try values.decodeIfPresent(String.self, forKey: .access_token)
        } catch {}
        
        do {
            expires_in = try values.decodeIfPresent(Int.self, forKey: .expires_in)
        } catch {}
        
        do {
            refresh_token = try values.decodeIfPresent(String.self, forKey: .refresh_token)
        } catch {}
        
        do {
            token_type = try values.decodeIfPresent(String.self, forKey: .token_type)
        } catch {}
        
        do {
            message = try values.decodeIfPresent(String.self, forKey: .message)
        } catch {}
        
        do {
            status_code = try values.decodeIfPresent(String.self, forKey: .status_code)
        } catch {
            let newStatusCode = try values.decodeIfPresent(Int.self, forKey: .status_code)
            self.status_code = newStatusCode?.string
        }
    }
}
