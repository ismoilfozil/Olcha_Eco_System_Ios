//
//  FoundOrderPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/12/22.
//


import UIKit
extension FoundOrderPage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(OrderProductRoom.self, for: indexPath)
        if products.isGreater(indexPath) {
            cell.setup(with: products[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        MyOrderRoom.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if products.isGreater(indexPath) {
            productHelper.pushProduct.send(products[indexPath.row])
        }
    }
}
