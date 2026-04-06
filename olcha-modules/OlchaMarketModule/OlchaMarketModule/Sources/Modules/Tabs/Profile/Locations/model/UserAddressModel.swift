//
//  RegionsModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 6/5/21.
//

import Foundation
struct UserAddressModel : Codable {
    var message: String?
    var status: String?
    var data: UserAddressData?
}

struct UserAddressData : Codable {
    var address: UserAddress?
    var new_address: UserAddress?
}

struct OrdinaryModel : Codable {
    var message: String?
    var status: String?
    var data: OrdinaryData?
}

struct OrdinaryData : Codable {
    var success: Bool?
}
