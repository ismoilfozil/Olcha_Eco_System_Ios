//
//  UIScreen+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/01/23.
//

import Foundation
import UIKit
public extension UIScreen {
    static let width = UIScreen.main.bounds.width
    
    /// The size of a brightness change step
    private static let step: CGFloat = 0.05
    
    /// Change the screen brightness in an animated way
    ///
    /// - Parameter to: Target brightness percentage
    static func setBrightness(to value: CGFloat) {
        guard abs(UIScreen.main.brightness - value) > step else { return }
        
        let delta = UIScreen.main.brightness > value ? -step : step
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            UIScreen.main.brightness += delta
            setBrightness(to: value)
        }
    }
}
