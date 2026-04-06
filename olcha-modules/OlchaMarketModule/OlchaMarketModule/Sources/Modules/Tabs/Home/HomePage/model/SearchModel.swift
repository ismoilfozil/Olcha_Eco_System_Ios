//
//  SearchModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 2/10/21.
//

public struct SearchCategory : Codable {
    var category: [CategoryModel]
}

public struct SearchBrands: Codable {
    var brands: [Manufacturer]
}

public struct SearchProducts : Codable {
    var products : [ProductModel]
}


//brand
public struct Manufacturer : Codable, Equatable {
    var id: Int?
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?
    var slug: String?
    var main_image : String?
    var isSelected: Bool?
    var isEnabled: Bool?
    var categories: [CategoryModel]?

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
    
    func getAlias() -> String {
        if let slug {
            return slug
        } else if let id {
            return "\(id)"
        }
        return ""
    }
}

//search brand data
public struct SourceBrand : Codable {
    var write_format_ru : String?
    var slug : String?
    var name_ru : String?
    var translate_ru : String?
    var name_uz : String?
    var name: String?
    var translate_oz : String?
    var write_ru : String?
    var id : Int?
    var write_format_oz : String?
    var image_hosts : Int?
    var name_oz : String?
    
    
    public enum CodingKeys : String, CodingKey {
        case write_format_ru = "write_format_ru"
        case slug = "slug"
        case name_ru = "name_ru"
        case name = "name"
        case translate_ru = "translate_ru"
        case name_uz = "name_uz"
        case translate_oz = "translate_oz"
        case write_ru = "write_ru"
        case id = "id"
        case write_format_oz = "write_format_oz"
        case image_hosts = "image_hosts"
        case name_oz = "name_oz"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        write_format_ru = try values.decodeIfPresent(String.self, forKey: .write_format_ru)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name_ru = try values.decodeIfPresent(String.self, forKey: .name_ru)
        translate_ru = try values.decodeIfPresent(String.self, forKey: .translate_ru)
        name_uz = try values.decodeIfPresent(String.self, forKey: .name_uz)
        translate_oz = try values.decodeIfPresent(String.self, forKey: .translate_oz)
        write_ru = try values.decodeIfPresent(String.self, forKey: .write_ru)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        write_format_oz = try values.decodeIfPresent(String.self, forKey: .write_format_oz)
        image_hosts = try values.decodeIfPresent(Int.self, forKey: .image_hosts)
        name_oz = try values.decodeIfPresent(String.self, forKey: .name_oz)
        
    }
    
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
