//
//  DarkView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 05/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import SnapKit

public class DarkView: UIView {}

public extension UIView {
    var showingDarkView: Bool {
        subviews.first(where: { $0 is DarkView }) != nil
    }
    
    func addDarkView(completion: (() -> Void)? = nil) {
        removeDarkView()
        
        DispatchQueue.main.async {
            let darkView = DarkView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            darkView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.addSubview(darkView)
            
            darkView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            darkView.fadeIn {
                completion?()
            }
        }
    }
    
    func removeDarkView(withAnimation: Bool = true) {
        DispatchQueue.main.async {
            for subview in self.subviews where subview is DarkView {
                if withAnimation {
                    subview.fadeOut { subview.removeFromSuperview() }
                } else {
                    subview.removeFromSuperview()
                }
            }
        }
    }
}
