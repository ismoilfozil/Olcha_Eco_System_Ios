//
//  ImageView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 22/11/22.
//

import UIKit
public class ImageView: UIImageView {

    public var cornerRadius: CGFloat = 0.0 { didSet { setUpView() } }

    public func setUpView() {
        self.clipsToBounds = true

        setTopCornerRadius(rect: self.bounds)
    }

    func setTopCornerRadius(rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners:[.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        self.layer.masksToBounds = true
    }
}
