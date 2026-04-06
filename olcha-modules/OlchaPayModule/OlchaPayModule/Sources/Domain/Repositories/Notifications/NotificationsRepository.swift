//
//  NotificationsRepository.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 25/03/23.
//

import Foundation
import Combine
import OlchaCore

public protocol NotificationsRepositoryProtocol {
    func loadNotifications(page: Int) -> AnyPublisher<(BaseResponse<NotificationData, EmptyData>), Never>
    func readNotification(id: Int) -> AnyPublisher<(BaseResponse<NotificationData, EmptyData>), Never>
}

public class NotificationsRepository: BaseRepository, NotificationsRepositoryProtocol {
    
    public func loadNotifications(page: Int) -> AnyPublisher<(BaseResponse<NotificationData, EmptyData>), Never> {
        let api: NotificationsAPI = .notifications(page: page)
        return manager.request(api: api,
                               isSingleRequest: false,
                               isCancellable: false)
    }
    
    public func readNotification(id: Int) -> AnyPublisher<(BaseResponse<NotificationData, EmptyData>), Never> {
        let api: NotificationsAPI = .readNotification(id: id)
        return manager.request(api: api,
                               isSingleRequest: false,
                               isCancellable: false)
    }
    
}
