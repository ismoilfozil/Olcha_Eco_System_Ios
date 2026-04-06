//
//  DropDownMenu.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 07/02/23.
//

import UIKit
import DropDown

extension DropDown {
    public func configure(_ parentView: UIView, _ titles: [String], width: CGFloat? = nil, offset: CGFloat? = nil) {
        self.dataSource = titles
        self.anchorView = parentView
        if let width = width {
            self.width = width
        }
        self.cornerRadius = 8
        self.shadowOpacity = 0.8
        self.shadowRadius = 25
        self.backgroundColor = .olchaWhite
        if let offset = offset {
            self.bottomOffset = .init(x: -offset, y: 0)
        }
    }
}
