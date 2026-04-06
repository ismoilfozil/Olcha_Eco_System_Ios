//
//  UserAddressData.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/09/22.
//

import Foundation
import OlchaCore
struct UserAddressListData : Codable {
    var data: [UserAddress]?
    var paginator: Paginator?
}
