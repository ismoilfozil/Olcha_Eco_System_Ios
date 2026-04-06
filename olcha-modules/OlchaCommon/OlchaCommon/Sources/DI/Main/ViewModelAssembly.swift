//
//  MainViewModelAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import Foundation
import OlchaUtils
import Swinject
final class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CommonViewModel.self) { (r, organization: Organization) in
            let loadNotificationsUseCase = r.resolve(LoadNotificationsProtocol.self, argument: organization)!
            let readNotificationUseCase = r.resolve(ReadNotificationProtocol.self, argument: organization)!
            let loadFAQsUseCase = r.resolve(LoadFAQsProtocol.self, argument: organization)!
            let loadBannersUseCase = r.resolve(LoadBannersProtocol.self, argument: organization)!
            let storeFeedbackUseCase = r.resolve(StoreFeedbackProtocol.self, argument: organization)!
            return CommonViewModel(
                loadNotificationsUseCase: loadNotificationsUseCase,
                readNotificationUseCase: readNotificationUseCase,
                loadFAQsUseCase: loadFAQsUseCase,
                loadBannersUseCase: loadBannersUseCase,
                storeFeedbackUseCase: storeFeedbackUseCase
            )
        }

        container.register(VersionViewModel.self) { (r, organization: Organization) in
            let checkAppVersionUseCase = r.resolve(CheckAppVersionProtocol.self, argument: organization)!
            return VersionViewModel(
                checkAppVersionUseCase: checkAppVersionUseCase
            )
        }
        
        container.register(LoyaltyViewModel.self) { (r) in
            let nextLevelLoyaltyUseCase = r.resolve(LoadLoyaltyNextLevelProtocol.self)!
            let loadLoyaltyLevelsUseCase = r.resolve(LoadLoyaltyLevelsProtocol.self)!
            let loadLoyaltyUserLevelUseCase = r.resolve(LoadLoyaltyUserLevelProtocol.self)!
            return LoyaltyViewModel(
                useCase: .init(loadNextLevel: nextLevelLoyaltyUseCase,
                               loadLevels: loadLoyaltyLevelsUseCase,
                               loadUserLevel: loadLoyaltyUserLevelUseCase)
            )
        }
        
    }
}
