//
//  NotificationsUseCase.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 25/03/23.
//

import Foundation
import OlchaCore
import Combine

public protocol LoadNotificationsProtocol {
    func execute(page: Int) -> AnyPublisher<BaseResponse<NotificationData, EmptyData>, Never>
}

public protocol ReadNotificationProtocol {
    func execute(id: Int) -> AnyPublisher<BaseResponse<NotificationData, EmptyData>, Never>
}

public enum NotificationsUseCase {
    public class LoadNotifications: LoadNotificationsProtocol {
        
        private let repository: NotificationsRepositoryProtocol
        
        public init(repository: NotificationsRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(page: Int) -> AnyPublisher<BaseResponse<NotificationData, EmptyData>, Never> {
            repository.loadNotifications(page: page)
        }
    }
    
    public class ReadNotification: ReadNotificationProtocol {
        
        private let repository: NotificationsRepositoryProtocol
        
        public init(repository: NotificationsRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(id: Int) -> AnyPublisher<BaseResponse<NotificationData, EmptyData>, Never> {
            repository.readNotification(id: id)
        }
    }
    
}
