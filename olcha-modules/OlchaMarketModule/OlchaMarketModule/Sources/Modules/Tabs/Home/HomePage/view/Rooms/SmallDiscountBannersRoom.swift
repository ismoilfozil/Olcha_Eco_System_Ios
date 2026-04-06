//
//  SmallDiscountBannersRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/07/22.
//

import UIKit
import OlchaUI
class SmallDiscountBannersRoom: BaseTableCell {
    
    private let discountsCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func setupViews() {
        container.addSubview(discountsCollection)
    }
    
    override func autolayout() {
        self.discountsCollection.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        discountsCollection.backgroundColor = .olchaBackgroundColor
        self.discountsCollection.registerClass(forCell: DiscountBannerItem.self)
        self.discountsCollection.delegate = self
        self.discountsCollection.dataSource = self
        
        let manager = HomeLayoutManager()
        self.discountsCollection.collectionViewLayout = manager.getLayout(with: .gridItem(.init(width: 104, height: 104)))
        self.discountsCollection.backgroundColor = .clear
    }
}

extension SmallDiscountBannersRoom: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(DiscountBannerItem.self, for: indexPath)
        cell.layoutIfNeeded()
        cell.setup(with: nil)
        return cell
    }


}
