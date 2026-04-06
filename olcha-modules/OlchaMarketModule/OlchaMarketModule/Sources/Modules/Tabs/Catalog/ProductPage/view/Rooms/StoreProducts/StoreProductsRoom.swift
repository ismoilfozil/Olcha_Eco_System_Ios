//
//  StoreProductsRoom.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 02/11/23.
//

import UIKit
import OlchaUI
import Combine
class StoreProductsRoomView: BaseTableCellView {
    let maxCount: Int = 3
    
    private lazy var table: DynamicTable = {
        let table = DynamicTable()
        table.delegate = self
        
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: StoreGiftRoom.self)
        table.registerClass(forCell: StoreProductItem.self)
        table.registerClass(forCell: StoreProductFooteritem.self)
        table.registerClass(forCell: ComponentHeader.self)
        
        
        return table
    }()
    
    weak var pushStoreObserver: PassthroughSubject<Store?, Never>?
    weak var parentObserver: PassthroughSubject<ProductModel?, Never>?
    weak var openStoreProducts: PassthroughSubject<Bool, Never>?
    
    var product: ProductModel?
    var fullProduct: FullProductData?
    var parentProductEnabled: Bool = false
    
    override func setupViews() {
        container.addSubview(table)
    }
    
    override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setup(product: ProductModel?, fullProduct: FullProductData?, parentProductEnabled: Bool) {
        self.product = product
        self.fullProduct = fullProduct
        self.parentProductEnabled = parentProductEnabled
        self.table.reloadData()
    }
}

extension StoreProductsRoomView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getTableStoreProductsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isStoreProductHeader(indexPath) {
            let cell = tableView.dequeue(ComponentHeader.self, for: indexPath)
            cell.configure(with: .title("store_products_header".localized()))
            return cell
        }
        
        if isStoreProductItem(indexPath) {
            let cell = tableView.dequeue(StoreProductItem.self, for: indexPath)
            cell.pushStoreObserver = pushStoreObserver
            cell.parentObserver = parentObserver
            
            let actualCount = getActualStoreProductsCount()
            cell.setup(with: product?.storeProducts?[indexPath.row - 1],
                       product: product)
            
            if actualCount == 1 {
                cell.configure(with: .single)
            } else {
                cell.configure(with: .middle)
                if indexPath.row == 1 {
                    cell.configure(with: .top)
                } else if (indexPath.row) == (actualCount) && actualCount == (product?.storeProducts?.count ?? 0) {
                    cell.configure(with: .bottom)
                } else {
                    cell.configure(with: .middle)
                }
                
            }
             
            cell.parentProductButton.isUserInteractionEnabled = parentProductEnabled
            
            return cell
        }
        
        if isStoreProductFooter(indexPath) {
            let cell = tableView.dequeue(StoreProductFooteritem.self, for: indexPath)
            cell.setup(with: product?.storeProducts?.count ?? 0)
            cell.button.clicked { [weak self] in
                guard let self = self else { return }
                self.openStoreProducts?.send(true)
            }
            return cell
        }
        
        if isStoreProductSeparator(indexPath) {
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            cell.responder.withSeparator = false
            cell.responder.withEdge = false
            cell.responder.height = 24
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}

extension StoreProductsRoomView {
    fileprivate func isStoreProductHeader(_ indexPath: IndexPath) -> Bool {
        indexPath.row == 0
    }
    
    fileprivate func isStoreProductItem(_ indexPath: IndexPath) -> Bool {
        !isStoreProductHeader(indexPath) && !isStoreProductFooter(indexPath) && !isStoreProductSeparator(indexPath)
    }
    
    fileprivate func isStoreProductFooter(_ indexPath: IndexPath) -> Bool {
        indexPath.row > 0 && indexPath.row == (getTableStoreProductsCount() - 2) && getActualStoreProductsCount() > maxCount
    }
    
    fileprivate func isStoreProductSeparator(_ indexPath: IndexPath) -> Bool {
        indexPath.row > 0 && indexPath.row == (getTableStoreProductsCount() - 1)
    }
    
    fileprivate func getTotalStoreProductsCount() -> Int {
        product?.storeProducts?.count ?? 0
    }
    
    func getTableStoreProductsCount() -> Int {
        guard (getTotalStoreProductsCount() > 0),
              Funcs.isAvailableOneClick(fullProduct: fullProduct) else { return 0 }
        return getActualStoreProductsCount() + 2
    }
    
    fileprivate func getActualStoreProductsCount() -> Int {
        
        if getTotalStoreProductsCount() > maxCount {
            return maxCount + 1
        } else {
            return getTotalStoreProductsCount()
        }
    }
}
