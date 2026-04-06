//
//  AmountBannersRoom+Collection.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/06/23.
//

import UIKit
import OlchaUI
import OlchaBilling
extension AmountBannersRoom: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        balances.count + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeue(LimitRoom.self, for: indexPath)
            cell.setup(with: limitBalance)
            return cell
        } else {
            let cell = collectionView.dequeue(BalanceItem.self, for: indexPath)
            let model = balances[indexPath.item - 1]
            cell.setup(with: model)
            cell.responder.addIcon.clicked { [weak self] in
                guard let self = self else { return }
                self.pushFillBalance?.send(model)
            }
            return cell
        }
    }
    
}
