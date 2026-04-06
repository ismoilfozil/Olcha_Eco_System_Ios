//
//  HomeViewModelAssembly.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 24/02/23.
//

import Foundation
import Swinject
final class HomeViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NewsViewModel.self) { r in
            let loadNewsUseCase = r.resolve(LoadNewsProtocol.self)!

            return NewsViewModel(loadNewsUseCase: loadNewsUseCase)
        }
        
        container.register(NotificationsViewModel.self) { r in
            let loadNotificationsUseCase = r.resolve(LoadNotificationsProtocol.self)!
            let readNotificationUseCase = r.resolve(ReadNotificationProtocol.self)!
            
            return NotificationsViewModel(loadNotificationsUseCase: loadNotificationsUseCase, readNotificationUseCase: readNotificationUseCase)
        }
        
        container.register(SearchViewModel.self) { r in
            let searchProvidersUseCase = r.resolve(SearchProvidersProtocol.self)!
            return SearchViewModel(searchProvidersUseCase: searchProvidersUseCase)
        }
    }
}
