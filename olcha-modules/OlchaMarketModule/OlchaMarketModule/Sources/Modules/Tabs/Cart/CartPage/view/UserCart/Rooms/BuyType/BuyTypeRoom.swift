//
//  PaymentTypeRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/10/22.
//

import UIKit
import OlchaUI

class BuyTypeRoom: BaseTableCell {
    
    private let titleLabel = UILabel()
    
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var types: [BuyType] = [
        .cash,
    ]
    
    var selectedBuyType: BuyType?
    
    let itemHeight: CGFloat = 100
    
    var skeleton: Skeleton? {
        observers?.skeleton.buyTypes
    }
    
    var typesCount: Int {
        skeleton?.getCount(types.count) ?? types.count
    }
    
    weak var observers: CartObservers? {
        didSet {
            var newTypes: [BuyType] = []
            if creditTypeContains() {
                newTypes = [.cash, .credit]
            } else {
                newTypes = [.cash]
            }
            types = newTypes
            updateLayout()
        }
    }
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(collection)
    }
    
    override func autolayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        updateLayout()
    }
    
    override func configureViews() {
        titleLabel.style(.semibold, 24)
        titleLabel.textColor = .olchaTextBlack
        
        
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .olchaBackgroundColor
        collection.registerClass(forCell: PaymentTitleItem.self)
        
        if let layout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            collection.collectionViewLayout = layout
        }
    }
    
    func setup(selectedBuyType: BuyType?) {
        titleLabel.text = "order_type".localized()
        self.selectedBuyType = selectedBuyType
        collection.reloadData()
    }
    
    private func creditTypeContains() -> Bool {
        observers?.products.contains(where: { $0.plan != nil }) ?? false
    }
    
    private func updateLayout() {
        collection.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.height.equalTo(itemHeight * typesCount.cgfloat)
        }
        
    }
}
