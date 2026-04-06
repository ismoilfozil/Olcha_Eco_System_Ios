//
//  CustomSlider.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 27/07/22.
//

import UIKit
import AORangeSlider
public class CustomSlider: AORangeSlider {

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds: CGRect = self.bounds
        bounds = bounds.insetBy(dx: -50, dy: -50)
        
        return bounds.contains(point)
     }
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return true
    }
}
