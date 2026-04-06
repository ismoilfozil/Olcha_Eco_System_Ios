//
//  OnboardingViewControlleer+Collection.swift
//  OlchaNasiyaModule
//
//  Created by Axrorxo'ja on 10/05/23.
//

import UIKit
import OlchaUI
extension OnboardingViewController: CollectionDelegates {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = pages
        return pages
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(OnboardingImageRoom.self, for: indexPath)
        cell.setup(image: OnboardingConfigurator.image(index: indexPath.item))
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    public func pageUpdated(forced: Bool) {
        if forced {
            collection.scrollToItem(at: .init(row: currentPage, section: 0),
                                    at: .centeredHorizontally,
                                    animated: true)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageFloat = (scrollView.contentOffset.x / scrollView.frame.size.width)
        let pageInt = Int(round(pageFloat))
        
        currentPage = pageInt
    }
    
}
