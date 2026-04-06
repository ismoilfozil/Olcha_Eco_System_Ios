//
//  ComponentModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 23/08/22.
//

import Foundation

struct ComponentData: Codable {
    var builder: [ComponentModel]?
}
struct ComponentModel: Codable {
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?
    var component_name: String?
    var link: String?
    var header: ComponentDataModel?
    var content: ComponentDataModel?
    var component_type: String?
    
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

struct ComponentDataModel: Codable {
    var id: Int?
    var name: String?
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?
    var route: String?
    var content_type: String?
    var image_url_ru: String?
    var image_url_uz: String?
    var image_url_oz: String?
    var image_url: String?
    var open_type: String?
    var store_id: Int?
    var product_id: Int?
    var category_id: Int?
    var manufacturer_id: Int?
    var coordinates: [CoordinateModel]?
    
    func getImageUrl() -> String {
        let imageURL: String = .lang(image_url_ru, image_url_uz, image_url_oz)
        
        if imageURL != "" {
            return imageURL
        } else {
            return image_url ?? ""
        }
    }
}

class HomeComponentModel {
    var categoriesData: CatData?
    var productsData: ProductsData?
    var brands: ManufacturersData?
    var news: SlidersData?
    var component: ComponentModel?
    
    var isLoaded: Bool = false
    
    init(model: ComponentModel?) {
        self.component = model
    }
}
