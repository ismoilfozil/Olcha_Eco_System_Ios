//
//  CartPage.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 19/02/24.
//

import UIKit
import OlchaUI
import OlchaAuth

class CartPage: OlchaUI.BaseViewController<OlchaUI.EmptyNavigationBar> {
    
    let userCart = UserCartPage()
    let guestCart = GuestCartPage()
    
    weak var coordinator: CartCoordinatorProtocol?

    override func configureViews() {
        ignoreNavigationBar = true
        container.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AuthGlobalDefaults.isUser() {
            setupUserCart()
        } else {
            setupGuestCart()
        }
    }
    
    func setupGuestCart() {
        removeChildren()
        self.view.addSubview(guestCart.view)
        self.addChild(guestCart)
        guestCart.didMove(toParent: self)
        guestCart.coordinator = coordinator
    }
    
    func setupUserCart() {
        removeChildren()
        self.view.addSubview(userCart.view)
        self.addChild(userCart)
        userCart.didMove(toParent: self)
        userCart.coordinator = coordinator
    }
    
    func removeChildren() {
        userCart.removeFromParent()
        guestCart.removeFromParent()

        // Finally, remove the child’s view from the parent’s
        guestCart.view.removeFromSuperview()
        userCart.view.removeFromSuperview()
    }
}
