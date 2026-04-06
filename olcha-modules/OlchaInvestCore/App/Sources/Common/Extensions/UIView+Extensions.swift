//
//  UIView+Extensions.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 19/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

extension UIView {
    func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat, color: CGColor) {
        removeCAShapeLayers()
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color
        borderLayer.lineDashPattern = pattern
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.lineWidth = 3
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        layer.addSublayer(borderLayer)
    }
    
    func removeCAShapeLayers() {
        guard let sublayers = layer.sublayers else { return }
        for sublayer in sublayers where sublayer is CAShapeLayer {
            sublayer.removeFromSuperlayer()
        }
    }
    
    func leftToRightGradient(_ leftColor: UIColor,_ rightColor: UIColor) {
        removeCAGradientLayers()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [leftColor.cgColor, rightColor.cgColor]
        gradient.locations = [0.0, 0.5]
        gradient.startPoint = CGPoint(x: 0.8, y: 0.8)
        gradient.endPoint = CGPoint(x: 0.2, y: 0.2)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func topToBottomGradient(_ leftColor: UIColor,_ rightColor: UIColor) {
        removeCAGradientLayers()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [leftColor.cgColor, rightColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func fadeIn(completion: (() -> Void)? = nil) {
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        }) { _ in
            completion?()
        }
    }
    
    func fadeOut(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.isHidden = true
            completion?()
        }
    }
}
