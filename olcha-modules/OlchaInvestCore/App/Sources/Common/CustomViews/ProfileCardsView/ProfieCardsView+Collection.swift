//
//  ProfieCardsView+Collection.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 18/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

extension ProfieCardsView: CollectionDelegates {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        input.balancesSkeleton.getCount(input.balances.count)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ProfileCardsViewItem.self, for: indexPath)
        cell.configure(skeleton: input.balancesSkeleton)
        guard input.balances.isGreater(indexPath) else {
            return cell
        }
        let cellData = input.balances[indexPath.item]
        cell.setup(with: cellData, amountButtonClicked: amountButtonObserver)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        let width = input.balances.count > 1 ? size.width - 24 : size.width
        return CGSize(width: width, height: size.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard input.balances.isGreater(indexPath) else { return }
        output.balanceCollectionItem = input.balances[indexPath.item]
    }
    
}
