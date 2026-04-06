//
//  CartPage+UI.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 04/01/24.
//

import UIKit
import OlchaUI
import OlchaUtils
import Lottie
extension UserCartPage {
    func setupAnimation() {
        placeholder.addContent(view: animationView)
        
        guard let bundle = Bundle(identifier: BundleType.olchaMarketModule.identifier) else { return }
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.animation = LottieAnimation.named("cart", bundle: bundle)
        animationView.play()
    }
}
