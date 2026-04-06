//
//  CartVariationPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/11/22.
//

import UIKit

extension CartVariationPage: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .header:
            return 1
        case .openProduct:
            return (openType == .comeBack) ? 1 : 0
        case .actions:
            return (openType == .cart) ? 1 : 0
        case .variations:
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .header:
            
            let cell = tableView.dequeue(CartVariationHeaderRoom.self, for: indexPath)
            cell.productHelper = productHelper
            cell.setup(with: product, fullProduct: fullProduct)
            return cell
        case .openProduct:
            let cell = tableView.dequeue(CartVariationGoProductRoom.self, for: indexPath)
            cell.goProductObserver = goProductObserver
            cell.variationError = variationError
            cell.helper = helper
            cell.setup(fullProduct: fullProduct)
            return cell
        case .actions:
            let cell = tableView.dequeue(CartVariationActionsRoom.self, for: indexPath)
            cell.goCartObserver = goCartObserver
            cell.productHelper = productHelper
            cell.preOrderObserver = preOrderObserver
            cell.helper = helper
            cell.variationError = variationError
            cell.setup(with: product, fullProduct: fullProduct)
            return cell
        case .variations:
            let cell = tableView.dequeue(VariationsRoom.self, for: indexPath)
            cell.setup(with: helper)
            return cell
        }
    }
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = UITableView.automaticDimension
        return tableView.cacheHeights(height, indexPath: indexPath)
    }
    
}


