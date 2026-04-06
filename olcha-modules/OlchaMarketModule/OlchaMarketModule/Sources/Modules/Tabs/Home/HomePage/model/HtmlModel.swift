//
//  HtmlModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 29/08/22.
//

import Foundation
struct HtmlModel: Codable {
    var page: PageModel?
}

struct PageModel: Codable {
    var title_ru: String?
    var title_uz: String?
    var title_oz: String?
    
    var content_ru: String?
    var content_uz: String?
    var content_oz: String?
    
    var title: String?
    
    func getTitle() -> String {
        if let title = title {
            return title
        } else {
            return .lang(title_ru,
                         title_uz,
                         title_oz)
        }
    }
    
    var content: String?
    
    func getContent() -> String {
        if let content = content {
            return content
        } else {
            return .lang(content_ru,
                         content_uz,
                         content_oz)
        }
    }
}
