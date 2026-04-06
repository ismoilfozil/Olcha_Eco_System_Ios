//
//  UIViewController+Extension+Bonsai.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/07/22.
//

import UIKit
import BonsaiController

extension UIViewController: @preconcurrency BonsaiControllerDelegate {
    
    private static let insetBackgroundViewTag = 98721 //Cool number
    
    public func paintSafeAreaBottomInset(withColor color: UIColor = .olchaBackgroundColor) {
        guard #available(iOS 11.0, *) else {
            return
        }
        if let insetView = view.viewWithTag(UIViewController.insetBackgroundViewTag) {
            insetView.backgroundColor = color
            return
        }
        
        let insetView = UIView(frame: .zero)
        insetView.tag = UIViewController.insetBackgroundViewTag
        insetView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(insetView)
        view.sendSubviewToBack(insetView)
        
        insetView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        insetView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        insetView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        insetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        insetView.backgroundColor = color
    }
    
    public func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: containerViewFrame.width, height: containerViewFrame.height)
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let bonsai = BonsaiController(fromDirection: .bottom,
                                      backgroundColor: UIColor(white: 0, alpha: 0.5),
                                      presentedViewController: presented,
                                      delegate: self)
        bonsai.duration = 0.4
        bonsai.dismissDirection = .bottom
        bonsai.presentedView?.layer.cornerRadius = 0
        //        bonsai.presentedView?.backgroundColor = .white
        return bonsai
    }
    
    func animateWithKeyboard(
            notification: NSNotification,
            animations: ((_ keyboardFrame: CGRect) -> Void)?
        ) {
            
            let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
            let duration = notification.userInfo![durationKey] as! Double
            
            
            let frameKey = UIResponder.keyboardFrameEndUserInfoKey
            let keyboardFrameValue = notification.userInfo![frameKey] as! NSValue
            
            
            let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
            let curveValue = notification.userInfo![curveKey] as! Int
            let curve = UIView.AnimationCurve(rawValue: curveValue)!

            
            let animator = UIViewPropertyAnimator(
                duration: duration,
                curve: curve
            ) {
                
                animations?(keyboardFrameValue.cgRectValue)
                
                
                self.view?.layoutIfNeeded()
            }
            
            
            animator.startAnimation()
        }
    
}
