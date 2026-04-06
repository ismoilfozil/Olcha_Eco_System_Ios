//
//  ProfileAssembly.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 14/11/23.
//

import Swinject
import OlchaUtils
import OlchaBalance
import OlchaVerification

final class ProfileAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(LanguagePage.self) { r in
            LanguagePage()
        }
        
        container.register(SettingsPage.self) { r in
            SettingsPage()
        }
        
        container.register(UserFullLocationPage.self) { r in
            UserFullLocationPage()
        }
        
        container.register(FoundOrderPage.self) { r in
            FoundOrderPage()
        }
        
        container.register(SearchOrderPage.self) { r in
            SearchOrderPage()
        }
        
        container.register(OrderCancelPage.self) { r in
            OrderCancelPage()
        }
        
        container.register(ProfilePage.self) { r in
            let verificationViewModel: VerificationViewModel = OlchaVerificationDIContainer.shared.resolve()
            let balanceViewModel: BalanceViewModel = BalanceDIContainer.shared.resolve()
            return ProfilePage(verificationViewModel: verificationViewModel, balanceViewModel: balanceViewModel)
        }
        
        container.register(ComparePage.self) { r in
            ComparePage()
        }
        
        container.register(LocationsListPage.self) { r in
            LocationsListPage()
        }
        
        container.register(ProfileDataPage.self) { r in
            ProfileDataPage()
        }
        
        container.register(EditNameModalPage.self) { r in
            EditNameModalPage()
        }
        
        container.register(EditMailModalPage.self) { r in
            EditMailModalPage()
        }
        
        container.register(MyOrdersPage.self) { r in
            MyOrdersPage()
        }
        
        container.register(NotificationsPage.self) { r in
            NotificationsPage()
        }
        
        container.register(OrdersStepModalPage.self) { r in
            OrdersStepModalPage()
        }

        container.register(DeliveryCodeModalPage.self) { r in
            DeliveryCodeModalPage()
        }
        
        container.register(RamazanTimePage.self) { r in
            RamazanTimePage()
        }
    }
}
