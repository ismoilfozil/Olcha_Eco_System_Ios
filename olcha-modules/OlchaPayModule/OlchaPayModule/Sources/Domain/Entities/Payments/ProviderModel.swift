//
//  ProviderModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 27/03/23.
//

import Foundation
import OlchaCore

public struct ProvidersData: Codable {
    public var providers: [ProviderModel]?
    public var paginator: Paginator?
}

public struct ProviderData: Codable {
    public var providers: ProviderModel?
}

public struct ProviderModel: Codable {
    public var id: Int?
    public var title: String?
    public var title_short: String?
    public var category_id: Int?
    public var logo: LogoModel?
    public var service: [ServiceModel]?
    
    init(id: Int? = nil, title: String? = nil, title_short: String? = nil, category_id: Int? = nil, logo: LogoModel? = nil, service: [ServiceModel]? = nil) {
        self.id = id
        self.title = title
        self.title_short = title_short
        self.category_id = category_id
        self.logo = logo
        self.service = service
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.title_short = try container.decodeIfPresent(String.self, forKey: .title_short)
        self.category_id = try container.decodeIfPresent(Int.self, forKey: .category_id)
        self.logo = try container.decodeIfPresent(LogoModel.self, forKey: .logo)
        self.service = try container.decodeIfPresent([ServiceModel].self, forKey: .service)
    }
    
    public func isDisabled() -> Bool {
        
        switch service?.count {
        case 0:
            return true
        case 1:
            return (service?.first?.isDisabled() ?? true)
        default:
            return false
        }
        
    }
}

public struct LogoModel: Codable {
    public var logo: String?
    public var provider: Int?
}
