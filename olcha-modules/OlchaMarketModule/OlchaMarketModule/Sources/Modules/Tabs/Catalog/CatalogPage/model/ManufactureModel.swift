//
//  ManufactureModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 2/11/21.
//

import Foundation

struct ManufactureModel : Codable {
    var message: String?
    var status: String?
    var data: ManufactureBannerData?
}
struct ManufactureBannerData : Codable {
    var top_banners: [Slider]?
    var sidebar_banner: Slider?
    var sliders: [Slider]?
}

