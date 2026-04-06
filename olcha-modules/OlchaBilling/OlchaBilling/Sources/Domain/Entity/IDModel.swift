//
//  IDModel.swift
//  OlchaBankCards
//
//  Created by Elbek Khasanov on 22/06/23.
//

import Foundation
public struct EntityID: Codable {
    public let external_entity_id: Int
    public let payment_system_alias: String
}
