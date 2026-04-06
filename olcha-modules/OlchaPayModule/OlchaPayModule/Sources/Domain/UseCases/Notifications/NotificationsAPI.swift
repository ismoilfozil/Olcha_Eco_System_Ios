//
//  NotificationsAPI.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 25/03/23.
//

import Foundation
import OlchaCore
public enum NotificationsAPI {
    case notifications(page: Int)
    case readNotification(id: Int)
}

extension NotificationsAPI: BaseOlchaPayApi {
    public var queryItems: [URLQueryItem] {
        switch self {
        case .notifications(let page):
            return [.init(name: "page", value: page.string)]
        default:
            return []
        }
    }
    
    public var path: String {
        switch self {
        case .notifications:
            return "notifications/"
        case .readNotification(let id):
            return "notifications/\(id)/"
        }
    }
    
    public var method: RequestType {
        switch self {
        case .notifications:
            return .get
        case .readNotification:
            return .get
        }
    }
    
    public var body: Data? {
        var data: Data?
        
        switch self {
            default: break
        }
        
        return data
    }
    
    
}
