//
//  HorizontalProductsProvider.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/07/22.
//
import OlchaUI
import UIKit
import Combine
import SkeletonView
class ProductsCollectionProvider: NSObject, UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDataSource {
    private let manager = HomeLayoutManager()
    var productCellType: ProductCell.CellType = .shrink
    
    var skeletonEnabled = true
    
    var isCreditItem = false
    
    var products: [ProductModel] = [] {
        didSet {
            collection?.reloadData()
        }
    }
    
    weak var collection: UICollectionView? {
        didSet {
            collection?.delegate = self
            collection?.dataSource = self
            collection?.registerClass(forCell: ProductCell.self)
            collection?.scrollRectToVisible(.zero, animated: true)
            collection?.showsHorizontalScrollIndicator = false
            collection?.showsVerticalScrollIndicator = false
        }
    }
    
    weak var productHelper: ProductHelper?
    
    weak var skeleton: Skeleton? {
        didSet {
//            collection?.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skeleton?.getCount(products.count) ?? products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ProductCell.self, for: indexPath)
        cell.configure(skeleton: skeleton)
        cell.productHelper = productHelper
        cell.isCreditItem = isCreditItem
        cell.configure(with: self.productCellType, withSeparator: false)

        if products.isGreater(indexPath) {
            cell.setup(with: products[indexPath.item])
        } else {
            cell.layoutIfNeeded()
            cell.prepareForReuse()
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? BaseCollectionCell)?.cellWillAppear()
    }
    
    
    func configure(with products: [ProductModel],
                   cellType: ProductCell.CellType = .shrink,
                   isVertical: Bool,
                   space: CGFloat) {
        
        let layout = manager.getLayout(with: isVertical ? .verticalProducts : .horizontalProducts(space: space))
        
        self.collection?.collectionViewLayout = layout
        
        self.productCellType = cellType
        
        self.collection?.isScrollEnabled = !isVertical
        
        self.products = products
        
        if isVertical {
            collection?.backgroundColor = .clear
        }
    }
    
    func configureGroupedLayout(with products: [ProductModel]) {
        let layout = manager.getLayout(with: .groupedProducts(count: products.count))
        
        self.collection?.collectionViewLayout = layout
        self.productCellType = .shrink
        self.products = products
    }
    
    func setupDatas(products: [ProductModel]) {
        self.products = products
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if products.isGreater(indexPath) {
            productHelper?.pushProduct.send(products[indexPath.item])
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        ProductCell.classIdentifier
    }
    
}


