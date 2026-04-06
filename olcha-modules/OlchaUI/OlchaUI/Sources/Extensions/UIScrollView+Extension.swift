//
//  UIScrollView+Extension.swift
//  OlchaUI
//
//  Created by Akhrorkhuja on 02/08/23.
//

import UIKit

public extension UIScrollView {
    func scrollToView(view: UIView, animated: Bool, yOffset: CGFloat = 100) {
        guard let origin = view.superview else { return }
        let childStartPoint = origin.convert(view.frame.origin, to: self)
        self.scrollRectToVisible(
            CGRect(x: 0, y: childStartPoint.y - yOffset, width: 1, height: self.frame.height),
            animated: animated
        )
    }
    
    var isScrollingTop: Bool {
        panGestureRecognizer.translation(in: self).y > 0
    }
}
