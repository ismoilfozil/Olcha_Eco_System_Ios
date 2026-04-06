//
//  BannersModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 2/5/21.
//

import Foundation
public struct SlidersModel : Codable {
    var status: String?
    var message: String?
    var data: SlidersData?
}


public class Blog : Codable {
    var id: Int?
    var title_ru: String?
    var title_uz: String?
    var title_oz: String?
    var short_text_ru: String?
    var short_text_uz: String?
    var short_text_oz: String?
    var main_image_ru: String?
    var main_image_uz: String?
    var main_image_oz: String?
    var image_ru: String?
    var image_uz: String?
    var image_oz: String?
    var alias: String?
    var view_amount: Int?
    var created_at: String?
    
    var description_ru: String?
    var description_uz: String?
    var description_oz: String?
    
    var image: String?
    
    var title: String?
    
    var description: String?
    var trimmed_description: String?
    var trimmed_description_ru: String?
    var trimmed_description_uz: String?
    var trimmed_description_oz: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title_ru
        case title_uz
        case title_oz
        case short_text_ru
        case short_text_uz
        case short_text_oz
        case main_image_ru
        case main_image_uz
        case main_image_oz
        case image_ru
        case image_uz
        case image_oz
        case alias
        case view_amount
        case created_at
        
        case description_ru
        case description_uz
        case description_oz
        
        case image
        
        case title
        
        case description
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int?.self, forKey: .id)
        title_ru = try container.decode(String?.self, forKey: .title_ru)
        title_uz = try container.decode(String?.self, forKey: .title_uz)
        title_oz = try container.decode(String?.self, forKey: .title_oz)
        do {
            short_text_ru = try container.decode(String?.self, forKey: .short_text_ru)
            short_text_uz = try container.decode(String?.self, forKey: .short_text_uz)
            short_text_oz = try container.decode(String?.self, forKey: .short_text_oz)
        } catch {
        }
        do {
            main_image_ru = try container.decode(String?.self, forKey: .main_image_ru)
            main_image_uz = try container.decode(String?.self, forKey: .main_image_uz)
            main_image_oz = try container.decode(String?.self, forKey: .main_image_oz)
        } catch {}
        image_ru = try container.decode(String?.self, forKey: .image_ru)
        image_uz = try container.decode(String?.self, forKey: .image_uz)
        image_oz = try container.decode(String?.self, forKey: .image_oz)
        alias = try container.decode(String?.self, forKey: .alias)
        view_amount = try container.decode(Int?.self, forKey: .view_amount)
        created_at = try container.decode(String?.self, forKey: .created_at)
        description_ru = try container.decode(String?.self, forKey: .description_ru)
        description_uz = try container.decode(String?.self, forKey: .description_uz)
        description_oz = try container.decode(String?.self, forKey: .description_oz)
        do {
            image = try container.decode(String?.self, forKey: .image)
        } catch {}
        do {
            title = try container.decode(String?.self, forKey: .title)
        } catch {}
        do {
            description = try container.decode(String?.self, forKey: .description)
        } catch {}
        
        trimDescription()
        
    }
    
    func trimDescription() {
        
        trimmed_description = String(htmlEncodedString: description ?? "")
        trimmed_description_ru = String(htmlEncodedString: description_ru ?? "")
        trimmed_description_uz = String(htmlEncodedString: description_uz ?? "")
        trimmed_description_oz = String(htmlEncodedString: description_oz ?? "")
        
    }
    
    func getImage() -> String {
        if let image = image {
            return image
        } else {
            return .lang(image_ru,
                         image_uz,
                         image_oz)
        }
    }
    
    func getTrimmedDescription() -> String {
        
        if let description = trimmed_description,
           description != "" {
            return description
        } else {
            return .lang(trimmed_description_ru,
                         trimmed_description_uz,
                         trimmed_description_oz)
        }
    }
    
    func getDescription() -> String {
        if let description = description,
           description != "" {
            return description
        } else {
            return .lang(description_ru,
                         description_uz,
                         description_oz)
        }
    }
    
    func getTitle() -> String {
        if let title = title {
            return title
        } else {
            return .lang(title_ru,
                         title_uz,
                         title_oz)
        }
    }
    
}



