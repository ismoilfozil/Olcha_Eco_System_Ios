//
//  NotificationsViewModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 15/02/23.
//

import Foundation
import OlchaUI
import OlchaCore
public class NotificationsViewModel: BaseViewModel {
    
    private let loadNotificationsUseCase: LoadNotificationsProtocol
    private let readNotificationUseCase: ReadNotificationProtocol
    
    @Published var notifications: LoadingState<NotificationData, BaseErrorType> = .standart
    
    public init(loadNotificationsUseCase: LoadNotificationsProtocol,
                readNotificationUseCase: ReadNotificationProtocol
    ) {
        self.readNotificationUseCase = readNotificationUseCase
        self.loadNotificationsUseCase = loadNotificationsUseCase
    }
    
    func loadNotifications(page: Int) {
        loadNotificationsUseCase.execute(page: page)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.notifications = .success(baseResponse.response)
                    break
                default:
                    self.notifications = .failure(.init(message: baseResponse.error))
                    break
                }
            }.store(in: &bag)
    }
    
    func readNotification(notification: NotificationModel?) {
        guard !(notification?.isRead ?? false),
              let id = notification?.id else { return }
        readNotificationUseCase.execute(id: id)
            .sink { _ in
            }.store(in: &bag)
    }
}
