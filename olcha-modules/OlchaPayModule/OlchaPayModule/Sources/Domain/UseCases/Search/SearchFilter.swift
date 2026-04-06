//
//  SearchFilter.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 15/12/23.
//

import Foundation
public class SearchFilter {
    public var page: Int?
    public var search: String?
    public var categoryID: Int?
    
    public init(page: Int? = nil,
                search: String? = nil,
                categoryID: Int? = nil
    ) {
        self.page = page
        self.search = search
        self.categoryID = categoryID
    }
}
