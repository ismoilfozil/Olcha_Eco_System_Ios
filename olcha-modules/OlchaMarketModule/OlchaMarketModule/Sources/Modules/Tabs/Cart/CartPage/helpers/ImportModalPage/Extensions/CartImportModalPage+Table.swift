//
//  CartImportModalPage+Table.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 03/01/24.
//

import UIKit
extension CartImportModalPage: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        input.products.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ImportProductRoom.self, for: indexPath)
        cell.topSeparatorHidden = indexPath.row != 0
        if input.products.isGreater(indexPath) {
            cell.setup(data: input.products[indexPath.row])
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard input.products.isGreater(indexPath) else { return }
        coordinator?.pushProductPage(product: input.products[indexPath.row])
    }
    
}
