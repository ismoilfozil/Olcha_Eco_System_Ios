//
//  UIStoryboard+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/01/23.
//


import UIKit
import OlchaUtils
public protocol StoryboardLoadable {
    static func initViewController(bundleType: BundleType) -> Self
}

public extension StoryboardLoadable where Self: UIViewController {
    
    static func initViewController(bundleType: BundleType = .olchaMarketModule) -> Self {
        let storyboardName = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(identifier: bundleType.identifier))
        let viewController = storyboard.instantiate(self)
        return viewController
    }
}

public extension UIStoryboard {
    
    func instantiate<VC: UIViewController>(_ viewController: VC.Type) -> VC {
        guard let vc = self.instantiateInitialViewController() as? VC else {
            fatalError("Couldn't instantiate \(type(of: VC.self))")
        }
        
        return vc
    }
}
