//
//  CornerBorderView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 28/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit

public class CornerBorderView: UIView {
    public override func layoutSubviews() {
        super.layoutSubviews()
        addCustomBorder()
    }
    
    private func addCustomBorder() {
        // Remove any existing border sublayers before adding the new one
        layer.sublayers?
            .filter { $0.name == "customBorderLayer" }
            .forEach { $0.removeFromSuperlayer() }
        
        layer.sublayers?
            .filter { $0.name == "customBorderLayer" }
            .forEach { $0.removeFromSuperlayer() }
                
        // Create a new shape layer for the custom border
        let borderLayer = CAShapeLayer()
        borderLayer.name = "customBorderLayer"
        borderLayer.strokeColor = UIColor.olchaLightNeutralGray?.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 1.0
        
        // Create a path for the border lines
        let borderPath = UIBezierPath()
        
        let minX = bounds.minX
        let minY = bounds.minY
        let maxX = bounds.maxX
        let maxY = bounds.maxY
        
        let midX = bounds.midX
        let midY = bounds.midY
        
        // Draw lines on the top and bottom borders
        let horizontalOffset: CGFloat = 50
        
        borderPath.move(to: CGPoint(x: minX, y: minY))
        borderPath.addLine(to: CGPoint(x: midX - horizontalOffset, y: minY))
        
        borderPath.move(to: CGPoint(x: midX + horizontalOffset, y: minY))
        borderPath.addLine(to: CGPoint(x: maxX, y: minY))
        
        borderPath.move(to: CGPoint(x: minX, y: maxY))
        borderPath.addLine(to: CGPoint(x: midX - horizontalOffset, y: maxY))
        
        borderPath.move(to: CGPoint(x: midX + horizontalOffset, y: maxY))
        borderPath.addLine(to: CGPoint(x: maxX, y: maxY))
        
        // Draw lines on the left and right borders
        let verticalOffset: CGFloat = 70
        
        borderPath.move(to: CGPoint(x: minX, y: minY))
        borderPath.addLine(to: CGPoint(x: minX, y: midY - verticalOffset))
        
        borderPath.move(to: CGPoint(x: minX, y: midY + verticalOffset))
        borderPath.addLine(to: CGPoint(x: minX, y: maxY))
        
        borderPath.move(to: CGPoint(x: maxX, y: minY))
        borderPath.addLine(to: CGPoint(x: maxX, y: midY - verticalOffset))
        
        borderPath.move(to: CGPoint(x: maxX, y: midY + verticalOffset))
        borderPath.addLine(to: CGPoint(x: maxX, y: maxY))
        
        // Set the path for the shape layer
        borderLayer.path = borderPath.cgPath
        
        // Add the shape layer as a sublayer to the view's layer
        layer.addSublayer(borderLayer)
        
        // Draw a rectangle with no fill over the center region to clear it
        let clearRectPath = UIBezierPath(rect: CGRect(x: minX + 2, y: minY + 2, width: bounds.width - 4, height: bounds.height - 4))
        let clearRectLayer = CAShapeLayer()
        clearRectLayer.path = clearRectPath.cgPath
        clearRectLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(clearRectLayer)
    }
}

