//
//  UpdateCardEntity.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 24/03/23.
//

import Foundation
public struct UpdateCardRequest: Codable {
    var color: String?
    var status: String?
    var cardName: String?
}
