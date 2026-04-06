//
//  HomeSegmentModel.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 17/11/23.
//

import Foundation
struct HomeSegmentdata: Codable {
    var filters: [HomeSegmentModel]?
}
struct HomeSegmentModel: Equatable, Codable {
    var id: Int?
    var query: String?
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?

    func getName() -> String {
        .lang(name_ru, name_uz, name_oz)
    }
}
