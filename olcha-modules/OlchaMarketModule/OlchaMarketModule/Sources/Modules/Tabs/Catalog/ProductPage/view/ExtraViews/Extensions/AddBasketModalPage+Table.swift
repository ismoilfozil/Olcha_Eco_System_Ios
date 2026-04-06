//
//  AddBasketModalPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/07/22.
//

import UIKit
import OlchaUI
extension AddBasketModalPage: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (alsoSeenProductsData?.products?.isEmpty ?? true) ? 0 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let cell = tableView.dequeue(ComponentHeader.self, for: indexPath)
            cell.configure(with: .title("seen_with_product".localized()))
            return cell
        } else {
            let cell = tableView.dequeue(HorizontalPromotedRoom.self, for: indexPath)
            cell.setup(with: alsoSeenProductsData)
            cell.configure(style: .white,
                           withShowAll: false,
                           cellType: .shrink)
            cell.responder.productHelper = productHelper
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

