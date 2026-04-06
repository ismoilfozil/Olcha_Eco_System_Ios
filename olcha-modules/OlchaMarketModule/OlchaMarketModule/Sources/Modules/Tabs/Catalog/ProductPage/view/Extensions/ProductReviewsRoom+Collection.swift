//
//  ProductReviewsRoom+Collection.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/07/22.
//
import OlchaUI
import UIKit
extension ProductReviewsHeaderRoom: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = reviewFiles?.files?.count ?? 0
        if count > 4 {
            return 4
        } else {
            return count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(CorneredImage.self, for: indexPath)
        cell.setup(with: reviewFiles?.files?[indexPath.item].full_path)
        
        if (reviewFiles?.files?.count ?? 0) > 4 {
            let count = (reviewFiles?.paginator?.total ?? 0) - 4
            cell.setImagesCount(isLast: indexPath.item == 3, count: count)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 3 {
            pushAllMedia?.send(0)
        } else {
            pushAllMedia?.send(indexPath.item)
        }
    }
}
extension ProductReviewsHeaderRoomView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = reviewFiles?.files?.count ?? 0
        if count > 4 {
            return 4
        } else {
            return count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(CorneredImage.self, for: indexPath)
        cell.setup(with: reviewFiles?.files?[indexPath.item].full_path)
        
        if (reviewFiles?.files?.count ?? 0) > 4 {
            let count = (reviewFiles?.paginator?.total ?? 0) - 4
            cell.setImagesCount(isLast: indexPath.item == 3, count: count)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 3 {
            pushAllMedia?.send(0)
        } else {
            pushAllMedia?.send(indexPath.item)
        }
    }
}

