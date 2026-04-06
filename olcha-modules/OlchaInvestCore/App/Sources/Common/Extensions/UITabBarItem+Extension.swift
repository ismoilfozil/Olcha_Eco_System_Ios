//
//  UITabBarItem+Extension.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 12/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit

extension UITabBarItem {
    var view: UIView {
        guard let view = self.value(forKey: "view") as? UIView else {
            return UIView()
        }
        return view
    }
}
