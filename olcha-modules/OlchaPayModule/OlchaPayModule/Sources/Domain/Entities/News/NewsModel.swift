//
//  NewsModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 16/02/23.
//

import Foundation
import Kingfisher
import OlchaCore
public class NewsModel: Codable {
    public var id: Int?
    public var title_ru: String?
    public var title_uz: String?
    
    public var description_ru: String?
    public var description_uz: String?
    
    public var main_image_ru: String?
    public var main_image_uz: String?
    
    public func getMainImage() -> String {
        .lang(main_image_ru, main_image_uz, main_image_uz)
    }
    
    public func getDescription() -> String {
        .lang(description_ru, description_uz, description_uz)
    }
    
    public func getTitle() -> String {
        return .lang(title_ru, title_uz, title_uz)
    }
}

public struct NewsData: Codable {
    public var news: [NewsModel]?
    public var paginator: Paginator?
}
