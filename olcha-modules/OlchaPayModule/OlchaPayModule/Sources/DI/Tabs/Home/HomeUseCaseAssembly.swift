//
//  HomeUseCaseAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 25/03/23.
//

import Foundation
import Swinject
final class HomeUseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoadNotificationsProtocol.self) { r in
            let repository = r.resolve(NotificationsRepositoryProtocol.self)!
            return NotificationsUseCase.LoadNotifications(repository: repository)
        }
        
        container.register(ReadNotificationProtocol.self) { r in
            let repository = r.resolve(NotificationsRepositoryProtocol.self)!
            return NotificationsUseCase.ReadNotification(repository: repository)
        }
        
        container.register(SearchProvidersProtocol.self) { r in
            let repository = r.resolve(SearchRepositoryProtocol.self)!
            return SearchUseCase.LoadProviders(repository: repository)
        }
    }
}
