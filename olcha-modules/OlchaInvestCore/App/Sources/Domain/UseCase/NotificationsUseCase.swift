//
//  NotificationsUseCase.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 17/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Combine
import OlchaCore

public protocol LoadNotificationsProtocol {
    func execute(page: Int) -> AnyPublisher<BaseResponse<InvestNotificationData, EmptyData>, Never>
}

public enum NotificationsUseCase {
    
    public class LoadNotifications: LoadNotificationsProtocol {
        private let repository: InvestHomeRepositoryProtocol
        
        public init(repository: InvestHomeRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(page: Int) -> AnyPublisher<BaseResponse<InvestNotificationData, EmptyData>, Never> {
            repository.loadNotifications(page: page)
        }
    }
    
}
