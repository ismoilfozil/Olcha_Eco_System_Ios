

import UIKit
import OlchaUI

class SliderZebra: UIView {
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    
    func drawItems(_ xPositions: [CGFloat]) {

        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        
        let size = CGSize(width: 2.0, height: self.frame.height)
        
        for i in 0..<xPositions.count {
            let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: xPositions[i] - 1.0, y: 0.0), size: size))
            imageView.image = .zebra_item?.scaleTo(CGSize(width: 2, height: 8.0))
            imageView.backgroundColor = .clear
            self.addSubview(imageView)
        }
        
        print(xPositions.count)
    }
    

}
