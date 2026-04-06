//
//  HomeNewsView+Collection.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 03/02/23.
//

import UIKit
import OlchaUI
extension HomeNewsView: CollectionDelegates {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skeleton.getCount(news.count)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(HomeNewsItem.self, for: indexPath)
        cell.configure(skeleton: skeleton)
        if news.isGreater(indexPath) {
            cell.setup(with: news[indexPath.item])
        } else {
            cell.prepareForReuse()
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 170, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if news.isGreater(indexPath) {
            newsClickedObserver?(indexPath.item)
        }
    }
}
