//
//  SlidersData.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/07/22.
//
import OlchaCore
import Foundation
public struct Filter : Codable {
    
}
public struct SlidersData : Codable {
    var sliders: [Slider]?
    var banners: [Slider]?
    var blogs: [Blog]?
    var filter: Filter?
    var paginator: Paginator?
    var pagination_color: String?
}

public struct Slider : Codable {
    var id: Int?
    var title_ru: String?
    var title_uz: String?
    var title_en: String?
    var title_oz: String?
    
    var description_ru: String?
    var description_uz: String?
    var description_oz: String?
    
    var url_ru: String?
    var url_uz: String?
    var url_oz: String?
    var url: String?
    
    var image: String?
    var image_ru: String?
    var image_uz: String?
    var image_oz: String?
    
    var mobile_image: String?
    var mobile_image_ru: String?
    var mobile_image_uz: String?
    var mobile_image_oz: String?
    
    var type: String?
    var `typealias`: String?
    var status: Int?
    
    var position: String?
    
    
    var route: String?
    
    var queryparams: String?
    
    var sort_type: String?
    
    public func getTypeAlias() -> SliderTypeAlias {
        if let `typealias` = `typealias`,
            let type = SliderTypeAlias(rawValue: `typealias`) {
            return type
        }
        return .none
    }
    
    public func getSearchQuery() -> String {
        if let queryparams = queryparams {
            return queryparams
                .replacingOccurrences(of: "q=", with: "")
                .replacingOccurrences(of: "+", with: " ")
        }
        return ""
    }
    
    public func getMobileImage() -> String {
        if let image = mobile_image {
            return image
        } else {
            return .lang(mobile_image_ru,
                         mobile_image_uz,
                         mobile_image_oz)
        }
    }
    
    public func getImage() -> String {
        if let image = image {
            return image
        } else {
            return .lang(image_ru,
                         image_uz,
                         image_oz)
        }
    }
    
    var description: String?
    
    public func getDescription() -> String {
        if let description = description {
            return description
        } else {
            return .lang(description_ru,
                         description_uz,
                         description_oz)
        }
    }
    
    var title: String?
    
    public func getTitle() -> String {
        if let title = title {
            return title
        } else {
            return .lang(title_ru,
                         title_uz,
                         title_oz)
        }
    }
    
    public func getURL() -> String {
        if let url = url {
            return url
        } else {
            return .lang(url_ru, url_uz, url_oz)
        }
    }
    
    func getSortType() -> ProductsSortItem {
        if let sort_type {
            return ProductsSortItem(rawValue: sort_type) ?? .popular
        } else {
            return .popular
        }
    }
}
