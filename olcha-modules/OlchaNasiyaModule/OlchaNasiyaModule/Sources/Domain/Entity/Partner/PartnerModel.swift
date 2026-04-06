//
//  PartnerModel.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import Foundation
public struct PartnerModel: Codable {
    public var id: Int?
    
    public var name_ru: String?
    public var name_uz: String?
    public var name_oz: String?
    public var name: String?
    
    public var main_image: String?
    public var addressess: [PartnerLocation]?
    public var categories: [CategoryModel]?
    public var description: String?
    public var description_ru: String?
    public var description_uz: String?
    public var description_oz: String?
    
    public var slug: String?
    
    public func getImageURL() -> String {
        main_image ?? ""
    }
    
    public func getTitle() -> String {
        if let name {
            return name
        } else {
            return .lang(name_ru, name_uz, name_oz)
        }
    }
    
    public func getDescription() -> String {
        if let description {
            return description
        } else {
            return .lang(description_ru, description_uz, description_oz)
        }
    }
    
    
    public static func mock(_ id: Int = 1) -> Self {
        .init(id: id,
              name_ru: "Store \(id)",
              name_uz: "Store \(id)",
              name_oz: "Store \(id)",
              name: "Store \(id)",
              
              main_image: "https://olcha.uz/uploads/images/manufacturer/KK/KK/Bs/1644645853.png",
              
              addressess: [
                .mock(),
                .mock()
              ],
              description: "Вас приветствует MacBro — крупнейший в Узбекистане интернет-магазин телефонов, планшетов и других гаджетов от ведущих производителей планеты. Мы уже более 15 лет реализуем продукцию Apple, а также Samsung и Xiaomi. Компания является крупнейшим дистрибьютором этих брендов, что позволило создать оптимальные для покупателей условия. Ознакомьтесь с возможностями, которые открывает перед покупателями в Ташкенте и других городах РУз наш онлайн-магазин телефонов. Здесь же вы найдете ответы на самые популярные вопросы клиентов, задаваемые специалистам службы поддержки MacBro.Разнообразный ассортимент, в котором представлены лучшие модели телефонов, планшетов, ноутбуков и другой продукции от ведущих производителей цифровой электроники, — далеко не единственная причина, по которой покупатели отдают предпочтение нам. Обращаясь в интернет-магазин смартфонов MacBro, клиенты открывают для себя следующие возможности:", slug: ""
        )
    }
    
}


public struct PartnerLocation: Codable {
    public var title: String?
    public var title_ru: String?
    public var title_uz: String?
    public var title_oz: String?
    
    public var phone: String?
    
    public func getTitle() -> String {
        if let title {
            return title
        }
        return .lang(title_ru, title_uz, title_oz)
    }
    
    public static func mock() -> Self {
        return .init(title: "Город Ташкент, Яккасарайский район, ул. Шота Руставели 150",
                     title_ru: "Город Ташкент, Яккасарайский район, ул. Шота Руставели 150",
                     title_uz: "Город Ташкент, Яккасарайский район, ул. Шота Руставели 150",
                     title_oz: "Город Ташкент, Яккасарайский район, ул. Шота Руставели 150",
                     phone: "+998 78 777 20 20")
    }
}

public class CategoryModel: Codable, PartnersFilterModel {
    public var main_image: String?
    public var id: Int?
    public var background_image: String?
    public var alias: String?
    public var name: String?
    public var parent_id: Int?
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

