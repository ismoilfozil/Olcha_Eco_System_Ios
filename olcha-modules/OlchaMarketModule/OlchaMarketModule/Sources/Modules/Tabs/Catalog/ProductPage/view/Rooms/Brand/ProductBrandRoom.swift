//
//  ProductBrandRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/07/22.
//

import UIKit
import OlchaUI
import Combine
class ProductBrandRoom: BaseTableCell {
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var brand: Manufacturer?
    private var categories: [CategoryModel] = []
    
    var style: PromotedRoomView.ProductCellStyle = .white
    
    weak var pushCategoryObserver: PassthroughSubject<(CategoryModel?, Manufacturer?), Never>?

    weak var pushBrandObserver: PassthroughSubject<Manufacturer?, Never>?
    
    
    override func setupViews() {
        container.addSubview(collection)
    }
    
    override func autolayout() {
        self.collection.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.height.equalTo(240)
        }
    }
    
    override func configureViews() {
        self.collection.backgroundColor = .olchaBackgroundColor
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.registerClass(forCell: BrandCardItem.self)
        
        let manager = HomeLayoutManager()
        let layout = manager.getLayout(with: .banner)
        self.collection.collectionViewLayout = layout
    }
    
    func setup(with data: Manufacturer?, categories: [CategoryModel]) {
        self.brand = data
        self.categories = categories
        self.collection.reloadData()
    }
    
}

extension ProductBrandRoom: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(BrandCardItem.self, for: indexPath)
        cell.pushCategoryObserver = pushCategoryObserver
        cell.seeAllButton.clicked { [weak self] in
            guard let self = self else { return }
            self.pushBrandObserver?.send(self.brand)
        }
        
        cell.style = style
        cell.setup(with: self.brand, categories: self.categories)
        return cell
    }
}

class ProductBrandRoomView: BaseTableCellView {
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var brand: Manufacturer?
    private var categories: [CategoryModel] = []
    
    var style: PromotedRoomView.ProductCellStyle = .white
    
    weak var pushCategoryObserver: PassthroughSubject<(CategoryModel?, Manufacturer?), Never>?

    weak var pushBrandObserver: PassthroughSubject<Manufacturer?, Never>?
    
    
    override func setupViews() {
        container.addSubview(collection)
    }
    
    override func autolayout() {
        self.collection.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.height.equalTo(240)
        }
    }
    
    override func configureViews() {
        self.collection.backgroundColor = .olchaBackgroundColor
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.registerClass(forCell: BrandCardItem.self)
        
        let manager = HomeLayoutManager()
        let layout = manager.getLayout(with: .banner)
        self.collection.collectionViewLayout = layout
    }
    
    func setup(with data: Manufacturer?, categories: [CategoryModel]) {
        self.brand = data
        self.categories = categories
        self.collection.reloadData()
    }
    
}

extension ProductBrandRoomView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(BrandCardItem.self, for: indexPath)
        cell.pushCategoryObserver = pushCategoryObserver
        cell.seeAllButton.clicked { [weak self] in
            guard let self = self else { return }
            self.pushBrandObserver?.send(self.brand)
        }
        
        cell.style = style
        cell.setup(with: self.brand, categories: self.categories)
        return cell
    }
}
