//
//  CosmosView+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/07/22.
//

import UIKit
import Cosmos
import OlchaUI
extension CosmosView {
    func designCosmos(_ scale: CGFloat = 1.0 ,iconSize: CGFloat, _ filled: Bool? = true) {
        if filled == true {
            self.settings.filledImage = .star?.scaleTo(.init(width: iconSize,
                                                                            height: iconSize))
        } else {
            self.settings.filledImage = .bordered_star?
                .scaleTo(
                    .init(width: iconSize,
                          height: iconSize))
                .withTintColor(.olchaAccentColor , renderingMode: .alwaysOriginal)
        }
        self.settings.emptyImage = .unstar?
            .scaleTo(.init(width: iconSize,
                           height: iconSize))
            .withTintColor(.olchaAccentColor , renderingMode: .alwaysOriginal)
        
        self.backgroundColor = .clear
        self.settings.starSize = Double(iconSize)
        self.applyTransform(withScale: scale, anchorPoint: CGPoint(x: 0.0, y: 0.0))
    }
}
