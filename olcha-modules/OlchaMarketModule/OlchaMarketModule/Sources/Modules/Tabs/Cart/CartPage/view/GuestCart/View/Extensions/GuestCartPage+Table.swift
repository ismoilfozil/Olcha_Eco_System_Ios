//
//  GuestCartPage+Table.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 30/01/24.
//

import UIKit
extension GuestCartPage {
    enum Section {
        case header
        case products
    }
}

extension GuestCartPage: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .header:
            return 1
        case .products:
            return observers.skeleton.products.getCount(observers.products.count)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section] {
        case .header:
            let cell = tableView.dequeue(CartProductsHeaderRoom.self, for: indexPath)
            cell.headerView.selectButton.clicked { [weak self] in
                guard let self = self else { return }
                self.selectAllProducts()
            }
            
            cell.headerView.cancelButton.clicked { [weak self] in
                guard let self = self else { return }
                
                self.removeSelectedProducts()
                self.table.reloadData()
            }
            cell.setup(isChecked: observers.isAllProductsSelected())
            return cell
        case .products:
            let cell = tableView.dequeue(CartProductRoom.self, for: indexPath)
            cell.configure(skeleton: observers.skeleton.products)
            
            if observers.products.isGreater(indexPath) {
                
                let item = observers.products[indexPath.row]
                cell.setup(with: item)
                cell.configure(with: .cash)
                cell.switchIcon.clicked { [weak self] in
                    guard let self = self else { return }
                    self.changeState(index: indexPath.row)
                    cell.isSwitched = item.cartSelected ?? false
                }
                cell.removeButton.clicked { [weak self] in
                    guard let self = self else { return }
                    self.remove(product: item)
                    tableReloader()
                }
                cell.isSwitched = item.cartSelected ?? false
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch sections[indexPath.section] {
        case .products:
            guard observers.products.isGreater(indexPath) else { return }
            observers.navigation.productHelper.pushProduct.send(observers.products[indexPath.row])
        default: break
        }
    }
}

extension GuestCartPage {
    fileprivate func selectAllProducts() {

        let allFalseValue = observers.products.allSatisfy { $0.cartSelected == false }
        let allTrueValue = observers.products.allSatisfy { $0.cartSelected == true }
        
        if allTrueValue {
            observers.products.forEach { $0.cartSelected = false }
        } else if allFalseValue {
            observers.products.forEach { $0.cartSelected = true }
        } else {
            observers.products.forEach { $0.cartSelected = true }
        }
            
        table.reloadData()
    }
    
    fileprivate func removeSelectedProducts() {
        var items: [CartItem] = []
        let selectedProducts = observers.products.filter { $0.cartSelected == true }
        
        observers.products.removeAll(where: { $0.cartSelected == true })
        for product in selectedProducts {
            MetricEvents.shared.cartEvent(product, type: .minus)
            items.append(.init(product_id: product.id,
                               store_id: product.getStoreID(),
                               quantity: 0))
        }
        
        
        
        CartViewModel.shared.deleteCart(items: items)
        table.reloadData()
    }
    
    fileprivate func changeState(index: Int) {
        let product = observers.products[index]
        product.cartSelected = !(product.cartSelected ?? false)
        table.reloadData()
    }
    
    fileprivate func remove(product: ProductModel?) {
        MetricEvents.shared.cartEvent(product, type: .minus)
        CartViewModel.shared.deleteCart(items: [.init(product_id: product?.id,
                                                      store_id: product?.getStoreID(),
                                                      quantity: 0)])
        
        observers.products.removeAll(where: { $0.id == product?.id && $0.store_id == product?.getStoreID() })
        tableReloader()
    }
}
