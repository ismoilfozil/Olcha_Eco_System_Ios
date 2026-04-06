//
//  HButtonIcon+MenuButton.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 19/10/23.
//

import OlchaUI
import UIKit

extension HButtonIcon {
    public func configureSortButton() {
        setTitle(" ")
        round(8)
        darkBorder()
        setIcon(.down_anchor_black?.withTintColor(.olchaAccentColor, renderingMode: .alwaysOriginal))
    }
}
