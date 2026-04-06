//
//  OlchaBalanceRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/02/23.
//

import UIKit
import Combine
import OlchaUtils
import CenteredCollectionView
import OlchaAuth
import OlchaUI
class OlchaBalanceRoom: BaseTableCell {
    
    private lazy var collection: UICollectionView = {
        let layout = CenteredCollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width * 0.9,
                                height: collectionHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(centeredCollectionViewFlowLayout: layout)
        
        collection.registerClass(forCell: OlchaBalanceItem.self)
        collection.registerClass(forCell: OlchaBonusItem.self)
        collection.delegate = self
        collection.dataSource = self
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    private let separator = Divide()
    private let collectionHeight: CGFloat = 120
    
    let sections : [Section] = [
        .balance,
        .bonus
    ]
    
    var balance: Balance?
    var user: User?
    var bonus: Bonus?
    weak var skeleton: Skeleton?
    weak var pushFillBalance: PassthroughSubject<Bool, Never>?
    
    override func setupViews() {
        container.addSubview(collection)
        
        container.addSubview(separator)
    }
    
    override func autolayout() {
        collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(collectionHeight)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(collection.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        collection.reloadData()
    }
    
    func setup(with balance: Balance?, user: User?, bonus: Bonus?) {
        self.user = user
        self.balance = balance
        self.bonus = bonus
        
        DispatchQueue.main.async {
            self.collection.reloadData()
        }
    }
    
    func scroll(to cell: UICollectionViewCell.Type) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collection.scrollToFirstCell(ofType: cell)            
        }
    }
}


