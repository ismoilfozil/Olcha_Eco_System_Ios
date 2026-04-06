//
//  MainUseCaseAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import Foundation
import Swinject
import OlchaUtils

final class UseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoadNotificationsProtocol.self) { (r, organization: Organization) in
            let repository = r.resolve(CommonRepositoryProtocol.self, argument: organization)!
            return CommonUseCase.LoadNotifications(repository: repository)
        }
        
        container.register(ReadNotificationProtocol.self) { (r, organization: Organization) in
            let repository = r.resolve(CommonRepositoryProtocol.self, argument: organization)!
            return CommonUseCase.ReadNotification(repository: repository)
        }
        
        container.register(LoadFAQsProtocol.self) { (r, organization: Organization) in
            let repository = r.resolve(CommonRepositoryProtocol.self, argument: organization)!
            return CommonUseCase.LoadFAQs(repository: repository)
        }
        
        container.register(CheckAppVersionProtocol.self) { (r, organization: Organization) in
            let repository = r.resolve(CommonRepositoryProtocol.self, argument: organization)!
            return CommonUseCase.CheckAppVersion(repository: repository)
        }
        
        container.register(LoadBannersProtocol.self) { (r, organization: Organization) in
            let repository = r.resolve(CommonRepositoryProtocol.self, argument: organization)!
            return CommonUseCase.LoadBanners(repository: repository)
        }
        
        container.register(StoreFeedbackProtocol.self) { (r, organization: Organization) in
            let repository = r.resolve(CommonRepositoryProtocol.self, argument: organization)!
            return CommonUseCase.StoreFeedback(repository: repository)
        }
        
        container.register(LoadLoyaltyNextLevelProtocol.self) { r in
            let repository = r.resolve(LoyaltyRepositoryProtocol.self)!
            return LoyaltyUseCase.LoadLoyaltyNextLevel(repository: repository)
        }
        
        container.register(LoadLoyaltyLevelsProtocol.self) { r in
            let repository = r.resolve(LoyaltyRepositoryProtocol.self)!
            return LoyaltyUseCase.LoadLoyaltyLevels(repository: repository)
        }
        
        container.register(LoadLoyaltyUserLevelProtocol.self) { r in
            let repository = r.resolve(LoyaltyRepositoryProtocol.self)!
            return LoyaltyUseCase.LoadLoyaltyUserLevel(repository: repository)
        }
    }
}
