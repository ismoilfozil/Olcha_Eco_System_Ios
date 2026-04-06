//
//  NewsListViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 16/02/23.
//

import UIKit
import OlchaUI

import PinterestLayout

extension NewsListViewController: UICollectionViewDataSource, PinterestLayoutDelegate, UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return 240
    }
    
    public func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        0
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        news.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(NewsListItem.self, for: indexPath)
        if news.isGreater(indexPath) {
            cell.setup(news[indexPath.item])
        }
        cell.button.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pushDetailedNews(news: self.news,
                                               currentIndex: indexPath.item,
                                               currentPage: self.paging.current)
        }
        
        loadMore(indexPath.item)
        return cell
    }
}
