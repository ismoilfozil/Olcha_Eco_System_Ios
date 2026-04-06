//
//  FaqData.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 30/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation

public struct FaqModel {
    public var id: Int?
    
    public var title: String?
    public var title_ru: String?
    public var title_uz: String?
    public var title_oz: String?
    
    public var content: String?
    public var content_ru: String?
    public var content_uz: String?
    public var content_oz: String?
    
    public var isExpanded: Bool?
    
    init(id: Int? = nil, title: String? = nil, title_ru: String? = nil, title_uz: String? = nil, title_oz: String? = nil, content: String? = nil, content_ru: String? = nil, content_uz: String? = nil, content_oz: String? = nil, isExpanded: Bool? = nil) {
        self.id = id
        self.title = title
        self.title_ru = title_ru
        self.title_uz = title_uz
        self.title_oz = title_oz
        self.content = content
        self.content_ru = content_ru
        self.content_uz = content_uz
        self.content_oz = content_oz
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
        if let content {
            return content
        } else {
            return .lang(content_ru, content_uz, content_oz)
        }
    }
    
    public static func mock(_ id: Int? = 1) -> FaqModel {
        .init(
            id: id,
            title: "Сколько стоит пройти регистрацию?",
            title_ru: "Сколько стоит пройти регистрацию?",
            title_uz: "Сколько стоит пройти регистрацию?",
            title_oz: "Сколько стоит пройти регистрацию?",
            content: "Регистрация в системе Olcha Nasiya полностью бесплатная.",
            content_ru: "Регистрация в системе Olcha Nasiya полностью бесплатная.",
            content_uz: "Регистрация в системе Olcha Nasiya полностью бесплатная.",
            content_oz: "Регистрация в системе Olcha Nasiya полностью бесплатная.",
            isExpanded: false
        )
    }
}
