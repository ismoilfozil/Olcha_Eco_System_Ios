//
//  CartPage+Observers.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 04/01/24.
//

import Foundation
import OlchaVerification
import Combine
import OlchaBalance

public class ViewModelsFactory {
    lazy var authCredit = OlchaVerificationDIContainer.shared.authCreditViewModel()
    lazy var verification: VerificationViewModel = OlchaVerificationDIContainer.shared.resolve()
    lazy var balance: BalanceViewModel = BalanceDIContainer.shared.resolve()
    let locations = LocationsPageViewModel()
    let checkout = CheckoutViewModel()
    let profile = ProfilePageViewModel()
    let catalog = CatalogPageViewModel()
}
