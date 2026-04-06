//
//  DiscountBannersRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 01/07/22.
//

import UIKit
import Combine
import OlchaUI
import SnapKit
class DiscountBannersRoom: BaseTableCell {
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    private var discounts: [Discount] = []
    
    weak var pushDiscountObserver: PassthroughSubject<Discount?, Never>?
    
    override func setupViews() {
        container.addSubview(collection)
    }
    
    override func autolayout() {
        collection.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
    override func configureViews() {
        collection.backgroundColor = .olchaBackgroundColor
        collection.registerClass(forCell: DiscountBannerItem.self)
        collection.delegate = self
        collection.dataSource = self
        
        let manager = HomeLayoutManager()
        collection.collectionViewLayout = manager.getLayout(with: .discounts)
        
        
        backgroundColor = .olchaBackgroundColor
    }
    
    func setup(with data: [Discount]) {
        discounts = data
        collection.reloadData()
    }
    
}

extension DiscountBannersRoom: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discounts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(DiscountBannerItem.self, for: indexPath)
        cell.layoutIfNeeded()
        cell.setup(with: discounts[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushDiscountObserver?.send(discounts[indexPath.item])
    }

}
