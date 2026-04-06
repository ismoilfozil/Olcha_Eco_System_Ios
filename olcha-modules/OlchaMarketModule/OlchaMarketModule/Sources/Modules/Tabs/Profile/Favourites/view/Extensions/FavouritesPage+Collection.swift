//
//  FavouritesPage+Collection.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/09/22.
//

import UIKit
import OlchaUI
extension FavouritesPage: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        checkPaginator(index: indexPath.item)
        let cell = collectionView.dequeue(ProductCell.self, for: indexPath)
        cell.layoutIfNeeded()
        cell.productHelper = productHelper

        
//        cell.favouriteRemoving = { [weak self] in
//            guard let self = self, self.products.isGreater(indexPath.item) else { return }
//            self.products.remove(at: indexPath.item)
//            collectionView.reloadData()
//        }
        
        cell.favouriteRemoving = { [weak self] in
            guard let self = self else { return }
//            collectionView.performBatchUpdates({
                if self.products.isGreater(indexPath) {
                    self.products.remove(at: indexPath.item)
                    reloadCollection()
//                    collectionView.deleteItems(at: [indexPath])
                }
//            }, completion: nil)
        }
        
//        cell.favouriteRemoving = { [weak self] in
//            guard let self = self else { return }
//            if self.products.isGreater(indexPath.item) {
//                self.products.remove(at: indexPath.item)
//                collectionView.reloadData()
//            }
//        }
        
        
        if products.isGreater(indexPath) {
            cell.setup(with: products[indexPath.item])
            cell.configure(with: .shrink, withSeparator: false)
        }
        
        
        cell.listSeparators(indexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? BaseCollectionCell)?.cellWillAppear()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width / 2, height: Constants.shrinkProductCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if products.isGreater(indexPath) {
            productHelper.pushProduct.send(products[indexPath.item])
        }
    }
    
}
