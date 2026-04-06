//
//  UIViewController+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/04/23.
//

import UIKit
import OlchaUI
extension UIViewController {
    func openOffer() {
        let language = String.getAppLanguage()
        openSafari(
            urlString: MarketTexts.urls.offer.replacingOccurrences(
                of: "lang",
                with: language)
        )
    }
}
