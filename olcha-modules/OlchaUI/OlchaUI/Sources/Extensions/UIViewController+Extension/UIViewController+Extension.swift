//
//  UIViewController+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/12/22.
//

import UIKit
import MessageUI
import SafariServices
import OlchaCore
import OlchaUtils

public extension UIViewController {
    
    var topView: UIView? {
        guard let window = UIApplication.shared.keyWindow else { return nil }
        return window.subviews.first
    }
    
    func canLoad(index: Int, paging: Paging, list: [Any]) -> Bool {
        if index == (list.count - 3) {
            if !paging.isLoading {
                paging.current = paging.current + 1
                
                if paging.current <= paging.total {
                    paging.isLoading = true
                    return true
                }
            }
        }
        return false
    }
    
    func canLoad(paging: Paging, list: [Any]) -> Bool {
        
        if !paging.isLoading {
            paging.current = paging.current + 1
            
            if paging.current <= paging.total {
                
                paging.isLoading = true
                return true
            }
        }
        
        return false
    }
    
}

//MARK: - Bonsai
public extension UIViewController {

    func dismissConfiguration(_ dismissHeight: CGFloat = 0) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDismiss))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        var viewTranslation = CGPoint(x: 0, y: 0)
        switch sender.state {
            case .changed:
                viewTranslation = sender.translation(in: view)
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    if viewTranslation.y > -16.0 {
                        self.view.transform = CGAffineTransform(translationX: 0, y: viewTranslation.y)
                    }
                })
                break
            case .ended:
                viewTranslation = sender.translation(in: view)
                print(viewTranslation.y)
                if viewTranslation.y < 120.0 {
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.view.transform = .identity
                    })
                } else {
                    dismiss(animated: true, completion: nil)
                }
            break
            
            
        default:
            break
        }
    }
    
}

extension UIViewController: StoryboardLoadable {
    public func viewControllerType() -> UIViewController.Type {
        return Self.self
    }
}

public extension UIViewController {
    func enableLogger(state: Bool = true) {
        guard state, Config.isTestFlightOrDebug else { return }
        //        guard (Texts.url.olcha.base == Texts.url.olcha.test) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            let button = IconButton()
            button.setIcon(.bag?.withTintColor(.black))
            UIApplication.shared.keyWindow?.addSubview(button)
            
            button.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(80)
                make.top.equalToSuperview().inset(50)
                make.width.height.equalTo(32)
            }
            
            button.clicked { [weak self] in
                guard let self = self else { return }
                let vc = LogTableViewController()
                vc.changeBaseURL = {
                    Texts.url.changeType()
                }
                UIApplication.shared.rootNavigationController?.push(vc)
            }
        }
    }
    
    func popToRoot(mainTabIndex: Int) {
        if tabBarController?.selectedIndex != mainTabIndex {
            UIApplication.shared.main?.navigationController?.popToRootViewController(animated: true)
            tabBarController?.selectedIndex = mainTabIndex
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self else { return }
            UIApplication.shared.main?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func popToMainTab(mainTabIndex: Int) {
        popToRoot(mainTabIndex: mainTabIndex)
    }
    
    private func popRoot() {
        
        if let navController = (self as? UINavigationController) {
            navController.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}
