//
//  CategoriesGroupView+Collection.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 31/03/23.
//

import UIKit
import OlchaUI
extension CategoriesGroupView: CollectionDelegates {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        skeleton.getCount(items.count)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(CategoryItem.self, for: indexPath)
        cell.configure(skeleton: skeleton)
        if items.isGreater(indexPath) {
            cell.setup(with: items[indexPath.item])
        } else {
            cell.prepareForReuse()
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionHeight, height: collectionHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if items.isGreater(indexPath) {
            observer?(items[indexPath.item])
        }
    }
}
