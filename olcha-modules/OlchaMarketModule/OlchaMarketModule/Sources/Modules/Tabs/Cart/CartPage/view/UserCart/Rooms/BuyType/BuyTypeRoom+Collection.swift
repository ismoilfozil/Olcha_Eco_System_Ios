//
//  PaymentTypeRoom+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/10/22.
//

import UIKit
import OlchaUI

extension BuyTypeRoom: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        typesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(PaymentTitleItem.self, for: indexPath)
        cell.configure(skeleton: skeleton)
        if types.isGreater(indexPath) {
            let item = types[indexPath.item]
            cell.setup(title: item.title,
                       subtitle: item.subtitle)
            cell.isChosen = (selectedBuyType == item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width , height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if types[indexPath.item] == .credit {
            observers?.navigation.credit.send()
        } else {
            observers?.action.buyTypeSelected.send(types[indexPath.item])
        }
    }
}
