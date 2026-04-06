//
//  ReturnOrderProducts+Table.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 18/10/23.
//

import UIKit
extension ReturnOrderProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        input.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ReturnOrderProductRoom.self, for: indexPath)
        cell.setup(with: input.products[indexPath.row])
        
        cell.cancelButton.clicked { [weak self] in
            guard let self else { return }
            coordinator?.pushReturnOrderProduct(order: input.order, product: input.products[indexPath.row])
        }
        
        return cell
    }
    
}
