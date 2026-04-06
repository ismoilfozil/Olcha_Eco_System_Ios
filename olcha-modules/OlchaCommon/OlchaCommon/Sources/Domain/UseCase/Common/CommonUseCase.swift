//
//  NotificationUseCase.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 12/05/23.
//
import Combine
import OlchaCore
import Foundation
import OlchaUtils
public protocol LoadNotificationsProtocol {
    func execute(page: Int, type: CommonNotificationType) -> AnyPublisher<BaseResponse<CommonNotificationData, EmptyData>, Never>
}

public protocol ReadNotificationProtocol {
    func execute(id: Int) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public protocol LoadFAQsProtocol {
    func execute(page: Int) -> AnyPublisher<BaseResponse<CommonFAQData, EmptyData>, Never>
}

public protocol CheckAppVersionProtocol {
    func execute(version: String) -> AnyPublisher<BaseResponse<VersionModel, EmptyData>, Never>
}

public protocol LoadBannersProtocol {
    func execute() -> AnyPublisher<BaseResponse<BannerData, EmptyData>, Never>
}

public protocol StoreFeedbackProtocol {
    func execute(model: FeedbackModel) -> AnyPublisher<BaseResponse<FeedbackModel, EmptyData>, Never>
}

public enum CommonUseCase {
    public class LoadNotifications: LoadNotificationsProtocol {
        private let repository: CommonRepositoryProtocol
        
        public init(repository: CommonRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(page: Int, type: CommonNotificationType) -> AnyPublisher<BaseResponse<CommonNotificationData, EmptyData>, Never> {
            repository.loadNotifications(page: page, type: type)
        }
    }
    
    public class ReadNotification: ReadNotificationProtocol {
        private let repository: CommonRepositoryProtocol
        
        public init(repository: CommonRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(id: Int) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            repository.readNotification(id: id)
        }
    }
    
    public class LoadFAQs: LoadFAQsProtocol {
        private let repository: CommonRepositoryProtocol
        
        public init(repository: CommonRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(page: Int) -> AnyPublisher<BaseResponse<CommonFAQData, EmptyData>, Never> {
            repository.loadFAQs(page: page)
        }
        
    }
    
    public class CheckAppVersion: CheckAppVersionProtocol {
        private let repository: CommonRepositoryProtocol
        
        public init(repository: CommonRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(version: String) -> AnyPublisher<BaseResponse<VersionModel, EmptyData>, Never> {
            repository.checkAppVersion(version: version)
        }
    }
    
    
    public class LoadBanners: LoadBannersProtocol {
        private let repository: CommonRepositoryProtocol
        
        public init(repository: CommonRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<BannerData, EmptyData>, Never> {
            repository.loadBanners()
        }
    }
    
    public class StoreFeedback: StoreFeedbackProtocol {
        private let repository: CommonRepositoryProtocol
        
        public init(repository: CommonRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(model: FeedbackModel) -> AnyPublisher<BaseResponse<FeedbackModel, EmptyData>, Never> {
            repository.storeFeedback(model: model)
        }
    }
}

