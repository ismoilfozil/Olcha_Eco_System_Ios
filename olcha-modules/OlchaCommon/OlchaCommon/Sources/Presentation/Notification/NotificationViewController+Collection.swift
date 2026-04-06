//
//  NotificationViewController+Collection.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 20/02/24.
//

import UIKit
import OlchaUI

extension NotificationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    var maxCount: Int { 3 }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        maxCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(NotificationHeaderItem.self, for: indexPath)
        cell.setup(with: "TEST")
        cell.isChosen = true
        return cell
    }
    
}
