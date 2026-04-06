//
//  CitiesModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 6/5/21.
//

import Foundation
struct DistrictsModel : Codable {
    var message: String?
    var status: String?
    var data: DistrictsData?
}

struct DistrictsData : Codable {
    var districts: [District]?
}
