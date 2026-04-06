//
//  SuggestionData.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaCore

public struct SuggestionData: Codable {
    public var paginator: Paginator?
    public var blog_list: [SuggestionSectionModel]
}

public struct SuggestionSectionModel: Codable {
    public var section_name: String?
    public var blogs: [SuggestionItemModel]
}

public struct SuggestionItemModel: Codable {
    public var id: Int?
    public var createdAt: String?
    public var title: String?
    public var alias: String?
    public var view_amount: Int?
    public var image: String?
    public var images: String?
    public var section_name: String?
    public var descrption: String?
}
