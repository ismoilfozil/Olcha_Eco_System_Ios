//
//  UITabController.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/09/22.
//

import UIKit
fileprivate let TAB_TAG = 10213

public extension UITabBarController {
    
    func initShadow() {
        let tabGradientView = UIView(frame: self.tabBar.bounds)
        tabGradientView.tag = TAB_TAG
        tabGradientView.backgroundColor = UIColor.white
        tabGradientView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.tabBar.addSubview(tabGradientView)
        self.tabBar.sendSubviewToBack(tabGradientView)
        tabGradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        
        self.tabBar.clipsToBounds = false
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
    }
    
    func enableShadow() {
        self.tabBar.subviews.forEach {
            if $0.tag == TAB_TAG {
                $0.shadowAdd(offset: .zero, color: .gray, opacity: 0.6, radius: 4)
                $0.layer.borderWidth = 0
            }
        }
    }
    
    func disableShadow() {
        self.tabBar.subviews.forEach {
            if $0.tag == TAB_TAG {
                $0.shadowAdd(offset: .zero, color: .clear, opacity: 0.1, radius: 4)
                $0.border()
            }
        }
    }
    
}
