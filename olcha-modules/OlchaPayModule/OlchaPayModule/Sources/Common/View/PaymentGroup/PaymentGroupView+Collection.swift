//
//  PaymentGroupView+Collection.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 03/02/23.
//


import UIKit
import OlchaUI
extension PaymentGroupView: CollectionDelegates {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(PaymentGroupItem.self, for: indexPath)
        cell.withBorder = withBorder
        cell.setup()
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionHeight, height: collectionHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        observer?.pushPayment.send(true)
    }
}
