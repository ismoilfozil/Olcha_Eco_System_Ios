//
//  NasiyaFAQModel.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 14/05/23.
//
import OlchaCore
import UIKit
import Foundation
public struct CommonFAQData: Codable {
    public var paginator: Paginator?
    public var faqs: [CommonFAQModel]?
}

public class CommonFAQModel: Codable {
    public var id: String?
    
    public var title: String?
    public var title_ru: String?
    public var title_uz: String?
    public var title_oz: String?
    
    public var description: String?
    public var description_ru: String?
    public var description_uz: String?
    public var description_oz: String?
    
    public var isExpanded: Bool?
    
    init(id: String? = nil, title: String? = nil, title_ru: String? = nil, title_uz: String? = nil, title_oz: String? = nil, description: String? = nil, description_ru: String? = nil, description_uz: String? = nil, description_oz: String? = nil, isExpanded: Bool? = nil) {
        self.id = id
        self.title = title
        self.title_ru = title_ru
        self.title_uz = title_uz
        self.title_oz = title_oz
        self.description = description
        self.description_ru = description_ru
        self.description_uz = description_uz
        self.description_oz = description_oz
        self.isExpanded = isExpanded
    }
    
    public func getTitle() -> String {
        if let title {
            return title
        } else {
            return .lang(title_ru, title_uz, title_oz)
        }
    }
    
    public func getContent() -> String {
        if let description {
            return description
        } else {
            return .lang(description_ru, description_uz, description_oz)
        }
    }
    
    public static func mock(_ id: String? = "1") -> CommonFAQModel {
        CommonFAQModel(id: id,
                       title: "Сколько стоит пройти регистрацию?",
                       title_ru: "Сколько стоит пройти регистрацию?",
                       title_uz: "Сколько стоит пройти регистрацию?",
                       title_oz: "Сколько стоит пройти регистрацию?",
                       description: "Регистрация в системе Olcha Nasiya полностью бесплатная.",
                       description_ru: "Регистрация в системе Olcha Nasiya полностью бесплатная.",
                       description_uz: "Регистрация в системе Olcha Nasiya полностью бесплатная.",
                       description_oz: "Регистрация в системе Olcha Nasiya полностью бесплатная.",
                       isExpanded: false)
    }
}
