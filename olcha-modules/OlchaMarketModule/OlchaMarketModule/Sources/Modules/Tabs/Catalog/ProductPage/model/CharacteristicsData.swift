//
//  FeatureData.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 22/07/22.
//

import Foundation
public struct CharacteristicsData: Codable {
    public var features: [String: CharacteristicFeature]?
}

public struct CharacteristicFeature: Codable {
    public var name_ru: String?
    public var name_uz: String?
    public var name_oz: String?
    public var data: [CharacteristicFeatureData]?
    
    public var name: String?
    
    public func getName() -> String {
        if let name = name {
            return name
        } else {
            return .lang(name_ru,
                         name_uz,
                         name_oz)
        }
    }
}

public struct CharacteristicFeatureData: Codable {
    public var feature_name_ru: String?
    public var feature_name_uz: String?
    public var feature_name_oz: String?
    public var feature_value_name_ru: String?
    public var feature_value_name_uz: String?
    public var feature_value_name_oz: String?
    public var feature_value_name: String?
    public func getFeatureValueName() -> String {
        if let feature_value_name = feature_value_name {
            return feature_value_name
        } else {
            return .lang(feature_value_name_ru,
                         feature_value_name_uz,
                         feature_value_name_oz)
        }
    }
    
    public var feature_name: String?
    public func getFeatureName() -> String {
        if let feature_name = feature_name {
            return feature_name
        } else {
            return .lang(feature_name_ru,
                         feature_name_uz,
                         feature_name_oz)
        }
    }
}
