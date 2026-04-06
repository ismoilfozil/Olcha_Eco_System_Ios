//
//  CategoryModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 1/11/21.
//

import Foundation

public class CategoryModel : Codable, Equatable {
    static let allCategoryID = -3
    public static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        ((lhs.id ?? -1) == (rhs.id ?? -2)) && ((lhs.alias ?? "-1") == (rhs.alias ?? "-2")) && (lhs.children == rhs.children)
    }
    
    var id: Int?
    var parent_id:Int?
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?
    var name: String?
    var icon: String?
    var alias: String?
    var main_image: String?
    var home_image: String?
    var background_image: String?
    var images: [String]?
    var description_uz: String?
    var description_oz: String?
    var description_ru: String?
    
    var description: String?
    
    var image: String?
    
    var isChosen: Bool?
    var children: [CategoryModel]?
    
    
    var compareCount: Int?
    
    var products: Int?
    
    var categoryProducts: ProductsData?
    
    public var isAllCategory: Bool {
        (id ?? -4) == CategoryModel.allCategoryID
    }
    
    public enum CodingKeys : String, CodingKey {
        case id = "id"
        case parent_id = "parent_id"
        case name_ru = "name_ru"
        case name_uz = "name_uz"
        case name_oz = "name_oz"
        case name = "name"
        case icon = "icon"
        case alias = "alias"

        case main_image = "main_image"
        case home_image = "home_image"
        case images = "images"
        case description_uz = "description_uz"
        case description_oz = "description_oz"
        case description_ru = "description_ru"
        case description = "description"
        case image = "image"
        case children = "children"
        case compareCount = "compareCount"
        case products = "products"
        case background_image = "background_image"
        
    }
    
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        parent_id = try values.decodeIfPresent(Int.self, forKey: .parent_id)
        name_ru = try values.decodeIfPresent(String.self, forKey: .name_ru)
        name_uz = try values.decodeIfPresent(String.self, forKey: .name_uz)
        name_oz = try values.decodeIfPresent(String.self, forKey: .name_oz)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        alias = try values.decodeIfPresent(String.self, forKey: .alias)

        main_image = try values.decodeIfPresent(String.self, forKey: .main_image)
        home_image = try values.decodeIfPresent(String.self, forKey: .home_image)
        images = try values.decodeIfPresent([String].self, forKey: .images)
        description_ru = try values.decodeIfPresent(String.self, forKey: .description_ru)
        description_oz = try values.decodeIfPresent(String.self, forKey: .description_oz)
        description_uz = try values.decodeIfPresent(String.self, forKey: .description_uz)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        children = try values.decodeIfPresent([CategoryModel].self, forKey: .children)
        compareCount = try values.decodeIfPresent(Int.self, forKey: .compareCount)
        products = try values.decodeIfPresent(Int.self, forKey: .products)
        background_image = try values.decodeIfPresent(String.self, forKey: .background_image)
    }
    
    public init(id:Int? = nil, parent_id:Int? = nil, lft:Int? = nil, rgt:Int? = nil, depth:Int? = nil, name_ru:String? = nil, name_uz:String? = nil, name_oz:String? = nil, icon:String? = nil, alias:String? = nil, active:Int? = nil, url_ru:String? = nil, url_uz:String? = nil, url_oz:String? = nil, meta_title_ru:String? = nil, meta_title_uz:String? = nil, meta_title_oz:String? = nil, meta_description_ru:String? = nil, meta_description_uz:String? = nil, meta_description_oz:String? = nil, queue:Int? = nil, main_image:String? = nil, images:[String]? = nil, description_uz:String? = nil, description_ru:String? = nil, description_oz:String? = nil, image:String? = nil,
         isChosen: Bool? = false, children: [CategoryModel]? = nil, compareCount:Int? = nil, products:Int? = nil, background_image: String? = nil) {
        
        self.id = id
        self.parent_id = parent_id
        self.name_ru = name_ru
        self.name_oz = name_oz
        self.name_uz = name_uz
        self.icon = icon
        self.alias = alias
        self.main_image = main_image
        self.images = images
        self.description_uz = description_uz
        self.description_oz = description_oz
        self.description_ru = description_ru
        self.image = image
        self.children = children
        self.compareCount = compareCount
        self.products = products
        
        
        self.isChosen = isChosen
        self.background_image = background_image
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
    
    func getDescription() -> String {
        if let description = description {
            return description
        } else {
            return .lang(description_ru,
                         description_uz,
                         description_oz)
        }
    }
    
    public static func allCategory(categories: [CategoryModel]?) -> CategoryModel {
        CategoryModel(id: CategoryModel.allCategoryID,
                      name_ru: "Все категории",
                      name_uz: "Барча категориялар",
                      name_oz: "Barcha kategoriyalar",
                      alias: "",
                      children: categories ?? [])
    }
    
    
}


public struct SourceCategory : Codable {
    var name_uz : String?
    var name_oz : String?
    var id : String?
    var write_format_oz : String?
    var parent_image_hosts : String?
    var main_image : String?
    var translate_ru : String?
    var name_ru : String?
    var write_ru : String?
    var parent_product : Int?
    var image_hosts : Int?
    var parent_images : String?
    var write_format_ru : String?
    var images : String?
    var product_type : String?
    var alias : String?
    var translate_oz : String?
    
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

