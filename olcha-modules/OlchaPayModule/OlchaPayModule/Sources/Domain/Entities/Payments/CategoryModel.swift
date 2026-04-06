//
//  CategoryModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 27/03/23.
//

import Foundation
public struct CategoriesData: Codable {
    private var categories: [CategoryModel]?

    public func getCategories() -> [CategoryModel] {
        categories?.filter { $0.id != 23 && $0.id != 24 } ?? []
    }
}

public class CategoryModel: Codable {
    public var id: Int?
    public var logo: String?
    
    public var name_ru: String?
    public var name_uz: String?
    
    public func getTitle() -> String {
        .lang(name_ru, name_uz, name_uz)
    }
    
}
