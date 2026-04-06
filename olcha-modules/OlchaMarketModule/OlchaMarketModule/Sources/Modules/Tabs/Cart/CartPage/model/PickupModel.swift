

import Foundation

struct PickupModel : Codable {
    var message: String?
    var status: String?
    var data: PickupData?
}

struct PickupData : Codable {
    var regions: [Region]?
}

struct Region : Codable {
    
    var id: Int?
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?
    var alias: String?
    var parent_id: Int?
    var is_main: Int?
    var pickups: [Pickup]?
    
    var name: String?
    func getName() -> String {
        if let name = name {
            return name
        } else {
            return .lang(name_ru,
                         name_uz,
                         name_oz)
        }
    }
}

struct Pickup : Codable {
    var id: Int?
    var address_ru: String?
    var address_uz: String?
    var address_oz: String?
    var address: String?
    
    func getAddress() -> String {
        if let address = address {
            return address
        } else {
            return .lang(address_ru,
                         address_uz,
                         address_oz)
        }
    }
    
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?
    
    var description_ru: String?
    var description_uz: String?
    var description_oz: String?

    var work_time_ru: String?
    var work_time_uz: String?
    var work_time_oz: String?
    
    var work_time: String?
    
    func getWorkTime() -> String {
        if let work_time = work_time {
            return work_time
        } else {
            return .lang(work_time_ru,
                         work_time_uz,
                         work_time_oz)
        }
    }
    
    
    var how_to_get_ru: String?
    var how_to_get_uz: String?
    var how_to_get_oz: String?
    var how_to_get: String?
    
    func getHowToGet() -> String {
        if let how_to_get = how_to_get {
            return how_to_get
        } else {
            return .lang(how_to_get_ru,
                         how_to_get_uz,
                         how_to_get_oz)
        }
    }
    
    
    var lng: String?
    var lat: String?
    
    var min_price_in_sum: Int?
    var max_weight: Int?
    var weight_every: Int?
    var weight_every_price: Int?
    var extra_price: Int?
    var price: Int?
    
    var name: String?
    func getName() -> String {
        if let name = name {
            return name
        } else {
            return .lang(name_ru,
                         name_uz,
                         name_oz)
        }
    }
    
    var description: String?
    
    func getDescription() -> String {
        if let description = description {
            return description
        } else {
            return .lang(description_ru,
                         description_uz,
                         description_oz)
        }
    }
}
