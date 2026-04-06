//
//  StoreProductsPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/07/22.
//

import UIKit
import Combine

class StoreProductsPage: BaseViewController {
    private var bag = Set<AnyCancellable>()
    private let table = UITableView()
    var product: ProductModel?
    let pushStoreObserver = PassthroughSubject<Store?, Never>()
    weak var coordinator: ProductCoordinatorProtocol?
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(table)
    }
    
    override func autolayout() {
        super.autolayout()
        table.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.left.right.equalToSuperview()
        }
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.configure(style: .back)
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: StoreProductItem.self)
        table.configure()
    }
    
    override func setupObservers() {
        pushStoreObserver
            .sink { [weak self] data in
                guard let self = self, let data = data else { return }
                let filters = ProductListFilters()
                filters.stores = [data]
                self.coordinator?.pushProductsList(filters: filters)
            }.store(in: &bag)
    }

}

extension StoreProductsPage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        product?.storeProducts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(StoreProductItem.self, for: indexPath)
        cell.pushStoreObserver = pushStoreObserver
        cell.setup(with: product?.storeProducts?[indexPath.row], product: self.product)
        
        if indexPath.row == 0 {
            cell.configure(with: .top)
        } else if (indexPath.row == ((product?.storeProducts?.count ?? 0) - 1)) {
            cell.configure(with: .bottom)
        } else {
            cell.configure(with: .middle)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
