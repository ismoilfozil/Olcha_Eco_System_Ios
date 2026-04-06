//
//  AmountBannersRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/06/23.
//

import UIKit
import OlchaUI
import OlchaAuth
import OlchaUtils
import CenteredCollectionView
import OlchaBilling
import Combine

public class AmountBannersRoom: BaseTableCell {
    let collectionHeight: CGFloat = 140
    public lazy var collection: UICollectionView = {
        let layout = CenteredCollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width - 32,
                                height: collectionHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(centeredCollectionViewFlowLayout: layout)
        collection.registerClass(forCell: BalanceItem.self)
        collection.registerClass(forCell: LimitRoom.self)
        collection.delegate = self
        collection.dataSource = self
        collection.showsHorizontalScrollIndicator = false
        collection.setContentOffset(.zero, animated: false)
        return collection
    }()
    
    public var balances: [BillingCollectionItem] = []
    var user: User?
    var limitBalance: InstallmentLimitBalanceModel?
    
    
    weak var pushFillBalance: PassthroughSubject<BillingCollectionItem, Never>?
    
    public override func setupViews() {
        container.addSubview(collection)
    }
    
    public override func autolayout() {
        collection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(collectionHeight)
        }
    }
    
    public override func configureViews() {
        collection.reloadData()
    }
    
    public func setup(balances: [BillingCollectionItem],
                      user: User?,
                      limitBalance: InstallmentLimitBalanceModel?) {
        self.balances = balances
        self.user = user
        self.limitBalance = limitBalance
        
        collection.reloadData()
        
    }
}
