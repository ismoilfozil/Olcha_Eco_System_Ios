//
//  UIView+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//

import UIKit

public extension UIView {
    
    func pulse() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.transform = .init(scaleX: 0.96, y: 0.96)
        } completion: {  [weak self] _ in
            guard let self = self else { return }
            self.transform = .identity
        }
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    
    func round(_ radius: CGFloat = 12, topCorner: Bool = false, bottomCorner: Bool = false) {
        
        var corners: CACornerMask = []
        if topCorner {
            corners.insert([.layerMaxXMinYCorner, .layerMinXMinYCorner])
        }
        
        if bottomCorner {
            corners.insert([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        }
        
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func round(_ radius: CGFloat = 12,
               topLeftCorner: Bool = false,
               bottomLeftCorner: Bool = false,
               topRightCorner: Bool = false,
               bottomRightCorner: Bool = false
    ) {
        
        var corners: CACornerMask = []
        if topLeftCorner {
            corners.insert(.layerMinXMinYCorner)
        }
        
        if topRightCorner {
            corners.insert(.layerMaxXMinYCorner)
        }
        
        if bottomLeftCorner {
            corners.insert(.layerMinXMaxYCorner)
        }
        
        if bottomRightCorner {
            corners.insert(.layerMaxXMaxYCorner)
        }
        
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func round(_ radius: CGFloat = 12.0) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func border(with color: UIColor? = .olchaLightNeutralGray, width: CGFloat = 1.0) {
        self.layer.borderColor = color?.cgColor
        self.layer.borderWidth = width
    }
    
    func darkBorder(with color: UIColor? = .olchaTextBlack) {
        self.layer.borderColor = color?.cgColor
        self.layer.borderWidth = 2
    }
    
    func removeBorder() {
        self.layer.borderWidth = 0
    }
    
    func shadowAdd(offset: CGSize = .init(width: 0, height: 10),
                   color: UIColor = .black.withAlphaComponent(0.4),
                   opacity: Float = 0.5,
                   radius: CGFloat = 16.0) {
        if traitCollection.userInterfaceStyle == .light {
            self.layer.masksToBounds = false
            self.layer.shadowColor = (color).cgColor
            self.layer.shadowOffset = offset
            self.layer.shadowOpacity = opacity
            self.layer.shadowRadius = radius
        }
    }
    
    func rotate(degree: CGFloat = .pi, animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.transform = self.transform.rotated(by: degree)
            }
        } else {
            self.transform = self.transform.rotated(by: degree)            
        }
    }
    
    func applyTransform(withScale scale: CGFloat, anchorPoint: CGPoint) {
        layer.anchorPoint = anchorPoint
        let scale = scale != 0 ? scale : CGFloat.leastNonzeroMagnitude
        let xPadding = 1/scale * (anchorPoint.x - 0.5)*bounds.width
        let yPadding = 1/scale * (anchorPoint.y - 0.5)*bounds.height
        transform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: xPadding, y: yPadding)
    }
    
    
    
    func setGradientBackgroundImage(_ colorTop: UIColor, _ colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func topToBottomGradient(_ topColor: UIColor,_ bottomColor: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        
        print(self.frame.width)
        print(UIScreen.main.bounds)
        print(self.frame.size.width)
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: self.frame.size.height)
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func leftToRightGradient(_ leftColor: UIColor,_ rightColor: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [leftColor.cgColor, rightColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        switch location {
            case .bottom:
                shadowAdd(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
            case .top:
            shadowAdd(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        }
    }
    
    
    enum VerticalLocation: String {
        case bottom
        case top
    }
}

public extension UIView {
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
    
    func removeCAGradientLayers() {
        guard let sublayers = layer.sublayers else { return }
        for sublayer in sublayers where sublayer is CAGradientLayer {
            sublayer.removeFromSuperlayer()
        }
    }
}
