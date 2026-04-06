//
//  PartnersData.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import Foundation
import OlchaCore
public struct PartnersData: Codable {
    public var paginator: Paginator?
    public var stores: [PartnerModel]?
    
    public static func mock(page: Int, lastPage: Int = 3) -> Self {
        var paginator = Paginator()
        paginator.current_page = page
        paginator.last_page = lastPage
        return .init(paginator: paginator, stores: [
            .mock(1),
            .mock(2),
            .mock(3),
            .mock(4),
            .mock(5),
            .mock(6),
            .mock(7),
            .mock(8),
            .mock(9),
            .mock(10),
            .mock(11),
            .mock(12),
            .mock(13),
            .mock(14),
        ])
    }
}

public struct FullPartnerData: Codable {
    
    public var store: PartnerModel?
    
    public init(store: PartnerModel? = nil) {
        self.store = store
    }
    public static func mock(id: Int? = 1) -> Self {
        return FullPartnerData(store: .mock())
    }
}
