
import Foundation
import UIKit

struct FullProductModel : Codable {
    var message: String?
    var status: String?
    var data: FullProductData?
}

public struct FullProductData : Codable {
    var product: ProductModel?
    var variations: [Variation]?
    var feature_groups: [FeaturesGroup]?
}

public struct FeaturesGroup : Codable {
    var id: Int?
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?
    var features: [FullFeature]?
    
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

struct FullFeature : Codable {
    var feature: FeatureData?
    var value: FeatureValue?
    
    var id: Int?
    
    var name_uz: String?
    var name_ru: String?
    var name_oz: String?
    var group_id: Int?
    
    var values: [FeatureValue]?
    
    var position: Int?
    
    var height_name_ru: CGFloat?
    var height_name_uz: CGFloat?
    var height_name_oz: CGFloat?
    
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

public struct Variation : Codable {
    var id: Int?
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?
    var values: [FeatureValue]
    
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

struct GetVariationModel : Codable {
    var message : String?
    var status : String?
    var data : GetVariationData?
}

class GetVariationData : Codable {
    var id: Int?
    var name_en: String?
    var name_oz: String?
    var name_uz: String?
    var name_ru: String?
    var data : [VariationData]?
    var isImage: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name_en
        case name_oz
        case name_uz
        case name_ru
        case data
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int?.self, forKey: .id)
        name_en = try container.decode(String?.self, forKey: .name_en)
        name_ru = try container.decode(String?.self, forKey: .name_ru)
        name_uz = try container.decode(String?.self, forKey: .name_uz)
        name_oz = try container.decode(String?.self, forKey: .name_oz)
        data = try container.decode([VariationData]?.self, forKey: .data)
        checkTypes()
    }
    
    func checkTypes() {

        data?.forEach {
            if !($0.images?.isEmpty ?? true) {
                self.isImage = true
            }
        }
    }
    
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

struct Combination: Codable {
    let alias: String?
    let enabled: Bool
    let status: Int?
}

struct VariationData : Codable {
    var feature_id : Int?
    
    var feature_name_ru : String?
    var feature_name_uz : String?
    var feature_name_oz : String?
    var feature_name : String?
    
    var images : String?
    
    var feature_value_id: Int?
    var feature_value_name_ru : String?
    var feature_value_name_uz : String?
    var feature_value_name_oz : String?
    var feature_value_name : String?
    
    var active: Bool = false
    
    func getFeatureName() -> String {
        if let feature_name = feature_name {
            return feature_name
        } else {
            return .lang(feature_name_ru,
                         feature_name_uz,
                         feature_name_oz)
        }
    }
    
    func getFeatureValueName() -> String {
        if let feature_value_name = feature_value_name {
            return feature_value_name
        } else {
            return .lang(feature_value_name_ru,
                         feature_value_name_uz,
                         feature_value_name_oz)
        }
    }
}
