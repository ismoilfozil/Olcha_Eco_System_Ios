//
//  GradientView.swift
//  NewOlcha
//
//  Created by Muhammadjon on 7/25/21.
//

import UIKit
class CardGradientView: UIView {
    override open class var layerClass: AnyClass {
       return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = true
    }
    
    func setColors(_ top: UIColor, _ bottom: UIColor) {
        
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [top.cgColor, bottom.cgColor]
    }
    func setRounded() {
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16
    }
}


