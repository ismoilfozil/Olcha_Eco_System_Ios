//
//  UIViewController+Alerts.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/10/22.
//


import UIKit
import OlchaUtils
import OlchaUI
extension UIViewController {
    
    
    public func showLogout(observer: @escaping (() -> Void)) {
        let alert = BaseAlert(type: .submit(text: "really_logout".localized()))
        alert.agreeClicked = observer
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showDeleteAccount(observer: @escaping (() -> Void)) {
        let alert = BaseAlert(type: .submit(text: "really_delete_account".localized()))
        alert.agreeClicked = observer
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showWarning(text: String, observer: (() -> Void)? = nil) {
        let alert = BaseAlert(type: .warning(text: text))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    public func showAddressDeleteSubmit(observer: @escaping ( () -> Void)) {
        let alert = BaseAlert(type: .submit(text: MarketTexts.deleteSubmitTitle))
        alert.agreeClicked = observer
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showOrderSuccess(type: OrderSuccessAlertView.SuccessType,
                                 homeObserver: @escaping (() -> Void),
                                 actionObserver: @escaping (() -> Void)) {
        let alert = BaseAlert(type: .orderSuccess(
            type: type,
            homeObserver: homeObserver,
            actionObserver: actionObserver)
        )
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    public func showAdult(dismissClicked: (() -> Void)? = nil, agreeClicked: (() -> Void)? = nil) {
        let alert = BaseAlert(type: .adult)
        alert.dismissClicked = dismissClicked
        alert.agreeClicked = agreeClicked
        self.present(alert, animated: true, completion: nil)
    }
    
}
