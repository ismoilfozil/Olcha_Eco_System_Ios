//
//  UIViewController+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/12/22.
//

import UIKit
import MessageUI
import SafariServices
import OlchaUtils
extension UIViewController: MFMailComposeViewControllerDelegate, SFSafariViewControllerDelegate {
    
    public func openSafari(urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        let vc = SFSafariViewController(url: url, configuration: config)
        present(vc, animated: true)
    }

}

extension UIViewController {

    public func openTelegram() {
        openURL(Texts.urls.olcha_telegram)
    }
    
    public func openPhone() {
        openURL("tel://" + "+" + Texts.urls.olcha_phone.phoneNumber)
    }
    
    public func openURL(_ urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
