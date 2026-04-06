//
//  FeaturesData.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/07/22.
//

import UIKit
enum FeatureType: String {
    case checkbox
    case colour
}

struct FeaturesData : Codable {
    var features: [FeatureData]?
    var manufacturers : [Manufacturer]?
}

struct FeatureData : Codable {
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
    var type: String?
    
    func getName() -> String {
        if let name = name {
            return name
        } else {
            return .lang(name_ru,
                         name_uz,
                         name_oz)
        }
    }
    
    func getFeatureType() -> FeatureType {
        guard let type = type,
                let featureType = FeatureType(rawValue: type) else {
            return .checkbox
        }
        return featureType
    }
}

struct FeatureValue : Codable {
    var id: Int?
    
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?
    
    var feature_id: Int?
    var isSelected: Bool?
    var isEnabled: Bool?
    var custom: Int?
    var `default`: Bool?
    
    var height_name_ru: CGFloat?
    var height_name_uz: CGFloat?
    var height_name_oz: CGFloat?
    
    var product_id: Int?
    
    var image_ru: String?
    var image_uz: String?
    var image_oz: String?
    
    var image: String?
    
    var colour_code: String?
    
    func getImage() -> String {
        if let image = image {
            return image
        } else {
            return .lang(image_ru,
                         image_uz,
                         image_oz)
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

struct PostOptionJSON: Codable {
    var feature_id: Int
    var value_id: Int
}
