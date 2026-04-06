//
//  RegionModel.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 25/07/23.
//

import Foundation
public struct RegionsData: Codable {
    public var regions: [RegionModel]?
}

public class RegionModel: Codable, PartnersFilterModel {
    
    public var id: Int?
    public var name: String?
    public var isSelected: Bool?
    
    public func getId() -> Int? {
        id
    }
    
    public func setId(id: Int?) {
        self.id = id
    }
    
    public func getTitle() -> String {
        name ?? ""
    }
    
    public func setTitle(_ str: String?) {
        self.name = str
    }
    
    public func getIsSelected() -> Bool {
        isSelected ?? false
    }
    
    public func setIsSelected(_ isSelected: Bool?) {
        self.isSelected = isSelected
    }
    
}
