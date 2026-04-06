//
//  UIStoryboard+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/01/23.
//


import UIKit
public protocol StoryboardLoadable {
    static func initViewController() -> Self
}

extension StoryboardLoadable where Self: UIViewController {
    
    public static func initViewController() -> Self {
        let storyboardName = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiate(self)
        return viewController
    }
}

extension UIStoryboard {
    
    public func instantiate<VC: UIViewController>(_ viewController: VC.Type) -> VC {
        guard let vc = self.instantiateInitialViewController() as? VC else {
            fatalError("Couldn't instantiate \(type(of: VC.self))")
        }
        
        return vc
    }
}
