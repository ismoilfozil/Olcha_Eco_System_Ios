//
//  CartProductsModalPage+Table.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 15/02/24.
//

import UIKit
extension CartProductsModalPage: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observers?.skeleton.products.getCount(observers?.products.count ?? 0) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let products = observers?.products ?? []
        let cell = tableView.dequeue(CartProductRoom.self, for: indexPath)
        cell.configure(skeleton: observers?.skeleton.products)
        cell.switchIcon.isHidden = true
        if products.isGreater(indexPath) {
            
            let item = products[indexPath.row]
            cell.setup(with: item)
            cell.configure(with: .cash)
            cell.removeButton.clicked { [weak self] in
                guard let self = self else { return }
                self.remove(product: item)
                tableReloader()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard (observers?.products.isGreater(indexPath) ?? false) else { return }
        observers?.navigation.productHelper.pushProduct.send(observers?.products[indexPath.row])
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    private func remove(product: ProductModel?) {
        MetricEvents.shared.cartEvent(product, type: .minus)
        CartViewModel.shared.deleteCart(items: [.init(product_id: product?.id,
                                                      store_id: product?.getStoreID(),
                                                      quantity: 0)])
        
        observers?.products.removeAll(where: { $0.id == product?.id && $0.store_id == product?.getStoreID() })
        table.reloadData()
    }
    
}
