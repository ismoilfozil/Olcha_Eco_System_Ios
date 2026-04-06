//
//  GradientView.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 02/02/23.
//

import UIKit
public class GradientView: UIView {

    var gradient = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupGradientView(_ topColor: UIColor, _ bottomColor: UIColor, points: (start: CGPoint, end: CGPoint) = (CGPoint(x: 1.0, y: 0.0), CGPoint(x: 0.0, y: 0.5))) {

        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = points.start
        gradient.endPoint = points.end
        self.layer.addSublayer(gradient)

    }

}
