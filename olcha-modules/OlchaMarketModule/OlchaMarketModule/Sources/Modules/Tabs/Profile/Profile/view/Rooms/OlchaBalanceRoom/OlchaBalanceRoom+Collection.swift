//
//  OlchaBalanceRoom+Collection.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/02/23.
//


import UIKit
import OlchaUI
extension OlchaBalanceRoom: UICollectionViewDelegate, UICollectionViewDataSource {
    
    enum Section: Int {
        case balance
        case bonus
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        skeleton?.getCount(sections.count) ?? sections.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard sections.isGreater(indexPath.item) else {
            
            let cell = collectionView.dequeue(OlchaBalanceItem.self, for: indexPath)
            cell.configure(skeleton: skeleton)
            return cell
            
        }
        
        switch sections[indexPath.item] {
        case .balance:
            let cell = collectionView.dequeue(OlchaBalanceItem.self, for: indexPath)
            cell.configure(skeleton: skeleton)
            cell.setup(with: balance, user: user)
            cell.balanceView.addIcon.clicked { [weak self] in
                guard let self = self else { return }
                self.pushFillBalance?.send(true)
            }
            return cell
        case .bonus:
            let cell = collectionView.dequeue(OlchaBonusItem.self, for: indexPath)
            cell.configure(skeleton: skeleton)
            cell.setup(with: bonus, user: user)
            return cell
        }
    }
    
}
