//
//  CustomSlider.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 01/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation

import UIKit
import OlchaUI

public class CustomSlider: UISlider {
    private let trackHeight: CGFloat = 4
    
    
    var thumbTouchSize : CGSize = CGSize(width: 30, height: 30)
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let bounds = self.bounds.insetBy(dx: -thumbTouchSize.width, dy: -thumbTouchSize.height)
        return bounds.contains(point)
    }
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        true
    }
    
    public override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var result = super.trackRect(forBounds: bounds)
        result.origin.x = 0
        result.size.width = bounds.size.width
        result.size.height = trackHeight
        return result
    }

    public override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        return super.thumbRect(forBounds:
            bounds, trackRect: rect, value: value)
            .offsetBy(dx: 0, dy: 0)
    }
    
}
