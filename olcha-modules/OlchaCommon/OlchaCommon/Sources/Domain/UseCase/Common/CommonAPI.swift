//
//  NotificationAPI.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 12/05/23.
//

import Foundation
import OlchaUtils
import OlchaCore
public protocol CommonAPIProtocol {
    var organization: Organization { get set }
    
    func notifications(page: Int, type: CommonNotificationType) -> BaseAPI
    func readNotification(id: Int) -> BaseAPI
    func faqs(page: Int) -> BaseAPI
    func feedback(model: FeedbackModel) -> BaseAPI
    func version(version: String) -> BaseAPI
    func banners() -> BaseAPI
}

public class CommonAPI: CommonAPIProtocol {
    public var organization: OlchaUtils.Organization
    
    public init(organization: OlchaUtils.Organization) {
        self.organization = organization
    }
    
    public func notifications(page: Int, type: CommonNotificationType) -> BaseAPI {
        
        let api = BaseCommonApi(path: "notifications",
                                method: .get,
                                queryItems: [
                                    .init(name: "page", value: page.string),
                                    .init(name: "type", value: type.rawValue)
                                ],
                                headers: CommonHeader.headers(organization: organization)
        )
        return api
    }
    
    public func readNotification(id: Int) -> BaseAPI {
        BaseCommonApi(
            path: "notifications/read/\(id)",
            method: .post,
            headers: CommonHeader.headers(organization: organization)
        )
    }
    
    public func faqs(page: Int) -> OlchaCore.BaseAPI {
        let api = BaseCommonApi(path: "faqs",
                                method: .get,
                                queryItems: [
                                    .init(name: "page", value: page.string)
                                ],
                                headers: CommonHeader.headers(organization: organization)
        )
        return api
    }
    
    public func feedback(model: FeedbackModel) -> BaseAPI {
        BaseCommonApi(path: "feedback",
                      method: .post,
                      body: model,
                      headers: CommonHeader.headers(organization: organization))
    }
    
    public func version(version: String) -> OlchaCore.BaseAPI {
        let headers = CommonHeader.headers(organization: organization, version: version)
        let api = BaseCommonApi(path: "versions",
                                version: Texts.url.getVersion(2),
                                method: .get,
                                headers: headers)
        return api
    }
    
    public func banners() -> OlchaCore.BaseAPI {
        let api = BaseCommonApi(path: "banners",
                                method: .get,
                                headers: CommonHeader.headers(organization: organization)
        )
        return api
    }
    
}
