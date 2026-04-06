//
//  ProfileAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 16/09/22.
//

import Foundation

import OlchaAuth
import OlchaCore
import OlchaUtils
enum ProfileAPI: OlchaMarketAPI {
    case userDatas
    case editUserDatas(model: EditUserProtocol)
    
    case notifications(page: Int)
    case readNotification(id: Int)
    
    case notification
    case settings
    case prayTimes(type: PrayTimeType, region_id: Int?)
    
    case registerPrayTimes(model: RamadanNotificationModel)
}

extension ProfileAPI {
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .notifications(let page):
            return [
                .init(name: "page", value: "\(page)")
            ]
        case .prayTimes(let type, let region_id):
            var regionQuery: URLQueryItem?
            if let region_id = region_id {
                regionQuery = URLQueryItem(name: "region_id", value: region_id.string)
            }
            
            return [
                .init(name: "type", value: type.rawValue),
                regionQuery
            ].compactMap { $0 }
            
        default: return []
        }
    }
    
    var path: String {
        switch self {
        case .userDatas:
            return "users"
        case .editUserDatas:
            return "users"
        case .notifications:
            return "user/notifications"
        case .readNotification(let id):
            return "user/notifications/\(id)/read"
        case .notification:
            return "user/device_token"
        case .settings:
            return "user-settings"
        case .prayTimes:
            return "get-times"
        case .registerPrayTimes:
            return "register-pray-times"
        }
    }
    
    var version: String {
        switch self {
        case .notifications: return Texts.url.getVersion(3)
        case .readNotification: return Texts.url.getVersion(3)
        default: return Texts.url.getVersion(2)
        }
    }
    
    var method: RequestType {
        switch self {
        case .userDatas: return .get
        case .editUserDatas: return .post
        case .notifications: return .get
        case .readNotification: return .get
        case .notification: return .post
        case .settings: return .get
        case .prayTimes: return .get
        case .registerPrayTimes: return .post
        }
    }
    
    var body: Data? {
        var data: Data?
        switch self {
            case .editUserDatas(let model):
            do {
                if let model = model as? EditUser {
                    data = try JSONEncoder().encode(model)
                } else if let model = model as? EditUserNoBirthdate {
                    data = try JSONEncoder().encode(model)
                }
            } catch {}
            break
        case .notification:
            do {
                let model = NotificationRegistrationModel()
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        case .registerPrayTimes(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        default: break
        }
        return data
    }
    
}
