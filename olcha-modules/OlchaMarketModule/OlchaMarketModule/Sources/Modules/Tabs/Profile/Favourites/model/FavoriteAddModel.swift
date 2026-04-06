//
//  FavoriteKeyModel.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 26/07/23.
//

import Foundation
public struct FavoriteAddModel: Codable {
    public var favorite_key: String?
    
    public enum CodingKeys: String, CodingKey {
        case favorite_key = "favorite-key"
    }
}
