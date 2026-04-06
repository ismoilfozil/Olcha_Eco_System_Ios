//
//  RamazanTaqvimModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 14/03/23.
//

import Foundation
enum PrayTimeType: String {
    case ramadan = "ramadan"
    case daily = "prayer"
}

struct RamazanTimesData: Codable {
    var timings: [PrayTimeModel]?
}

struct PrayTimeModel: Codable {
    var Bomdod: String?
    var Quyosh: String?
    var Peshin: String?
    var Asr: String?
    var Shom: String?
    var Xufton: String?
    
    var date: String?
    
    func getDayMonth() -> String {
        return date?.formatDate(("dd-MM-yyyy", "dd-MM")) ?? ""
    }
}

struct RamazanAudioModel: Codable {
    let title: String
    let content: String
    let audioPath: String
}
