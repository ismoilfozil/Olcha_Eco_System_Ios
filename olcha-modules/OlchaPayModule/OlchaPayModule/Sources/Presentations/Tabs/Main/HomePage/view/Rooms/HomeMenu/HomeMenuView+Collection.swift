//
//  HomeMenuRoom+Collection.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 02/02/23.
//

import UIKit
import OlchaUI
extension HomeMenuView: CollectionDelegates {
    
    enum Section {
        case my_cards
        case qr
        case dots
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.item] {
        case .my_cards:
            let cell = collectionView.dequeue(HomeMenuItem.self, for: indexPath)
            cell.setup(with: "my_cards".localized())
            cell.button.clicked { [weak self] in
                guard let self = self else { return }
                buttonClickObserver?(.my_cards)
            }
            return cell
        case .qr:
            let cell = collectionView.dequeue(HomeMenuItem.self, for: indexPath)
            cell.setup(with: "qr_scan".localized())
            cell.button.clicked { [weak self] in
                guard let self = self else { return }
                buttonClickObserver?(.qr)
            }
            return cell
        case .dots:
            let cell = collectionView.dequeue(HomeDotsItem.self, for: indexPath)
            cell.button.clicked {
                cell.dropDown.show()
            }
            return cell
        }
    }
    
}
