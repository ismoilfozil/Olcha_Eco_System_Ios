//
//  NasiyaHomeRepository.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 12/05/23.
//

import Foundation
import OlchaCore
import Combine
import OlchaUtils
public protocol CommonRepositoryProtocol {
    var api: CommonAPIProtocol { get set }
    func loadNotifications(page: Int, type: CommonNotificationType) -> AnyPublisher<BaseResponse<CommonNotificationData, EmptyData>, Never>
    func readNotification(id: Int) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
    func loadFAQs(page: Int) -> AnyPublisher<BaseResponse<CommonFAQData, EmptyData>, Never>
    func checkAppVersion(version: String) -> AnyPublisher<BaseResponse<VersionModel, EmptyData>, Never>
    func loadBanners() -> AnyPublisher<BaseResponse<BannerData, EmptyData>, Never>
    func storeFeedback(model: FeedbackModel) -> AnyPublisher<BaseResponse<FeedbackModel, EmptyData>, Never>
}

public class CommonRepository: BaseRepository, CommonRepositoryProtocol {
    
    public var api: CommonAPIProtocol
    
    public init(api: CommonAPIProtocol, manager: NetworkManagerProtocol) {
        self.api = api
        super.init(manager: manager)
    }
    
    public func loadNotifications(page: Int, type: CommonNotificationType) -> AnyPublisher<BaseResponse<CommonNotificationData, EmptyData>, Never> {
        return manager.request(api: api.notifications(page: page, type: type))
    }
    
    public func readNotification(id: Int) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        return manager.request(api: api.readNotification(id: id))
    }
    
    public func loadFAQs(page: Int) -> AnyPublisher<BaseResponse<CommonFAQData, EmptyData>, Never> {
        return manager.request(api: api.faqs(page: page))
    }
    
    public func checkAppVersion(version: String) -> AnyPublisher<BaseResponse<VersionModel, EmptyData>, Never> {
        return manager.request(api: api.version(version: version))
    }
    
    public func loadBanners() -> AnyPublisher<BaseResponse<BannerData, EmptyData>, Never> {
        return manager.request(api: api.banners(), isCancellable: true)
    }
    
    public func storeFeedback(model: FeedbackModel) -> AnyPublisher<BaseResponse<FeedbackModel, EmptyData>, Never> {
        manager.request(api: api.feedback(model: model))
    }
}
