//
//  StoreProductItem+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/03/23.
//

import UIKit
import OlchaUI
extension StoreProductItem: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        storeProduct?.gifts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(StoreGiftRoom.self, for: indexPath)
        if (storeProduct?.gifts?.isGreater(indexPath) ?? false) {
            cell.setup(with: storeProduct?.gifts?[indexPath.row])
        }
        return cell
    }
}
