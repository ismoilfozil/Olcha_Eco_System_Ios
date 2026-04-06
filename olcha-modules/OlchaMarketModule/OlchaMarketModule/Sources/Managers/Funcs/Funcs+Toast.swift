//
//  Funcs+Toast.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/12/22.
//

import Foundation
import Loaf
extension Funcs {
    static func showQuantityToast(quantity: Int?) {
        guard let quantity = quantity,
              let viewController = Funcs.getTopViewController() else { return }
        let text: String = .lang("В наличии всего \(quantity) штук товаров",
                                 "Омборда фақатгина \(quantity) та маҳсулот бор",
                                 "Omborda faqatgina \(quantity) ta mahsulot bor")
        Loaf.dismiss(sender: viewController)
        
        Loaf(text,
             state: .info,
             location: .bottom,
             presentingDirection: .left,
             dismissingDirection: .right,
             sender: viewController).show()
    }
}
