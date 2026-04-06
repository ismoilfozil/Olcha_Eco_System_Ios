//
//  UICollectionView+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//

import UIKit
import ViewAnimator
import Differ
import OlchaUI

extension UICollectionView {
    
    func animateProductShrink(_ type: ProductCell.CellType,
                              section: Int,
                              completed: @escaping (() -> Void)  ) {
        
        let animations: [StockAnimation] = [
            .fadeIn,
            .slide((type == .shrink) ? .up : .left, .slightly)
        ]
        
        self.spruce.prepare(with: animations)
        let function = LinearSortFunction(
            direction: (type == .shrink) ? .topToBottom : .leftToRight,
            interObjectDelay: 0.1)
        
        let animation = SpringAnimation(duration: 0.5)

        DispatchQueue.main.async {
            self.spruce.animate(animations,
                                animationType: animation,
                                sortFunction: function)
            completed()
        }
        
    }

}


