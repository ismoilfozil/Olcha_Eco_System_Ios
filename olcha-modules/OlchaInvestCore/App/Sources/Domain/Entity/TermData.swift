//
//  TermData.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
import OlchaCore

public struct TermData: Codable {
    public var paginator: Paginator?
    public var terms: [TermModel]
    
    public static func mock(page: Int, lastPage: Int = 3) -> TermData {
        var paginator = Paginator()
        paginator.current_page = page
        paginator.last_page = lastPage
        
        return TermData(paginator: paginator, terms: [
            .mock(),
            .mock(),
            .mock(),
            .mock(),
        ])
    }
}

public struct TermModel: Codable {
    public var id: Int
    public var month: String
    public var description: String
    public var risk: String
    
    public static func mock(id: Int = 1) -> TermModel {
        .init(
            id: id,
            month: "\(Int.random(in: 1...12)) месяцев",
            description: "Description Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem Lorem",
            risk: "\(Int.random(in: 10...50))%"
        )
    }
}
