//
//  UIViewController+Extensions.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 23/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaCore
import OlchaUI

public extension UIViewController {
    
    var topViewController: UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    var topView: UIView? {
        guard let window = keyWindow else { return nil }
        return window.subviews.first
    }

    var keyWindow: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .last { $0.isKeyWindow }
    }
    
    func observeTextFields(fields: InvestTField..., editing: (() -> Void)?) {
        fields.forEach { field in
            field.observeText(editing: editing)
        }
    }
    
    func showDeleteAccount(observer: @escaping (() -> Void)) {
        let alert = BaseAlert(type: .submit(text: "really_delete_account".localized()))
        alert.agreeClicked = observer
        self.present(alert, animated: true, completion: nil)
    }
    
    func showWarning(text: String, observer: (() -> Void)? = nil) {
        let alert = BaseAlert(type: .warning(text: text))
        alert.dismissClicked = observer
        self.present(alert, animated: true, completion: nil)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard Config.appConfiguration != .appStore, motion == .motionShake else { return }
        let vc = LogTableViewController()
        self.present(vc, animated: true)
    }
}

public extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
