//
//  NasiyaHomeViewModel.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 12/05/23.
//

import Foundation
import OlchaUI
import OlchaUtils
import OlchaCore

public class CommonViewModel: BaseViewModel {
    
    @Published public var notifications: LoadingState<CommonNotificationData, BaseErrorType> = .standart
    @Published public var faqs: LoadingState<CommonFAQData, BaseErrorType> = .standart
    @Published public var banners: LoadingState<BannerData, BaseErrorType> = .standart
    @Published public var feedback: LoadingState<FeedbackModel, BaseErrorType> = .standart
    
    
    private let loadNotificationsUseCase: LoadNotificationsProtocol
    private let readNotificationUseCase: ReadNotificationProtocol
    private let loadFAQsUseCase: LoadFAQsProtocol
    private let loadBannersUseCase: LoadBannersProtocol
    private let storeFeedbackUseCase: StoreFeedbackProtocol
    
    public init(loadNotificationsUseCase: LoadNotificationsProtocol,
                readNotificationUseCase: ReadNotificationProtocol,
                loadFAQsUseCase: LoadFAQsProtocol,
                loadBannersUseCase: LoadBannersProtocol,
                storeFeedbackUseCase: StoreFeedbackProtocol) {
        self.loadNotificationsUseCase = loadNotificationsUseCase
        self.readNotificationUseCase = readNotificationUseCase
        self.loadFAQsUseCase = loadFAQsUseCase
        self.loadBannersUseCase = loadBannersUseCase
        self.storeFeedbackUseCase = storeFeedbackUseCase
    }
    
    public func loadNotifications(page: Int, type: CommonNotificationType) {
        guard notifications != .loading else { return }
        notifications = .loading
        loadNotificationsUseCase.execute(page: page, type: type)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    notifications = .success(baseResponse.response)
                    break
                default:
                    notifications = .failure(
                        .init(message: baseResponse.error)
                    )
                    break
                }
            }.store(in: &bag)
    }
    
    public func readNotification(id: Int) {
        readNotificationUseCase.execute(id: id)
            .sink { [weak self] baseResponse in
                print(baseResponse.response)
            }.store(in: &bag)
    }
    
    public func loadFAQs(page: Int) {
        guard faqs != .loading else { return }
        faqs = .loading
        loadFAQsUseCase.execute(page: page)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    faqs = .success(baseResponse.response)
                    break
                default:
                    faqs = .failure(
                        .init(message: baseResponse.error)
                    )
                    break
                }
            }.store(in: &bag)
    }
    
    public func loadBanners() {
        guard banners != .loading else { return }
        banners = .loading
        
        loadBannersUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    banners = .success(baseResponse.response)
                default:
                    banners = .failure(.init(message: baseResponse.error))
                }
            }.store(in: &bag)
    }
    
    public func storeFeedback(model: FeedbackModel) {
        guard feedback != .loading else { return }
        feedback = .loading
        
        storeFeedbackUseCase.execute(model: model)
            .sink { [weak self] data in
                guard let self = self else { return }
                switch data.status {
                case .success:
                    feedback = .success(data.response)
                default:
                    feedback = .failure(.init(message: data.error))
                }
            }.store(in: &bag)
    }
}
