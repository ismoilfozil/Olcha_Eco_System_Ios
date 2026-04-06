//
//  TagModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/08/22.
//

import Foundation
struct TagData : Codable {
    var tags: [TagModel]?
}

struct TagModel: Codable {
    var slug: String?
    var name: String?
    var isSelected: Bool?
    var isEnabled: Bool?
}
