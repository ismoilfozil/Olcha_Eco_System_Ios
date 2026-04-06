//
//  UINavigationController+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 29/06/22.
//

import UIKit
import BonsaiController
import SPStorkController
public extension UINavigationController {
    static var tabless = false
    
    func dismissablePush(_ viewController: UIViewController, animated: Bool = true) {
        dismiss()
        push(viewController, animated: animated)
    }
    
    func push(_ viewController: UIViewController, animated: Bool = true) {
        if topViewController != viewController {
            viewController.hidesBottomBarWhenPushed = UINavigationController.tabless
            pushViewController(viewController, animated: animated)
        }
    }
    
    
    func set(_ viewControllers: [UIViewController], animated: Bool = true) {
        setViewControllers(viewControllers, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        popViewController(animated: animated)
    }
    
    func dismiss(animated: Bool = true) {
        dismiss(animated: animated, completion: nil)
    }
    
    @discardableResult
    func popViewController(to viewController: AnyClass, animated: Bool = true) -> UIViewController? {
        if let vc = viewControllers.last(where: { $0.isKind(of: viewController) }) {
            popToViewController(vc, animated: animated)
            return vc
        }
        return nil
    }
    
    @discardableResult
    func popViewController<T: UIViewController>(to viewControllerType: T.Type, animated: Bool = true) -> UIViewController? {
        if let vc = viewControllers.last(where: { $0 is T }) {
            popToViewController(vc, animated: animated)
            return vc
        }
        return nil
    }
    
    @discardableResult
    func popLastViewController(to viewController: AnyClass, animated: Bool = true) -> UIViewController? {
        
        if let index = self.viewControllers.firstIndex(where: { $0.viewControllerType() == viewController }), index > 0 {

            self.popViewController(to: self.viewControllers[index - 1].viewControllerType(), animated: animated)
            if let vc = viewControllers.last(where: { $0.isKind(of: viewController) }) {
                popToViewController(vc, animated: animated)
                return vc
            }

        }
        
        return nil
    }
    
    func getTopViewController() -> UIViewController? {
        
        if self.presentedViewController == nil {
            return self.topViewController
        } else {
            return self.presentedViewController
        }
        
    }
    
    func dismissPresentedViewController() {
        getTopViewController()?.dismiss(animated: true)
    }
    
    func isContains<T: UIViewController>(_ type: T.Type) -> Bool {
        return viewControllers.contains(where: { $0 is T })
    }

}

extension UIViewController {
    
    public func presentModally(_ viewController: UIViewController, animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            viewController.paintSafeAreaBottomInset()
            viewController.transitioningDelegate = self
            viewController.modalPresentationStyle = .custom
            self.present(viewController, animated: animated)
        }
    }
    
}
