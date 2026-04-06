//
//  ProfieCardsView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 17/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaBilling

public class ProfieCardsView: BaseView {

    public lazy var collection: DynamicCollection = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        let collection = DynamicCollection(frame: .zero, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.registerClass(forCell: ProfileCardsViewItem.self)
        return collection
    }()
    
    public var firstItem: ProfileCardsViewItem? {
        let cell: ProfileCardsViewItem? = collection.cell(at: 0, in: 0)
        return cell
    }
    public var amountButtonObserver: (() -> Void)?
    public var input: Input = .init()
    public var output: Output = .init()
    
    public override func setupViews() {
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
    }
    
    public override func autolayout() {
        collection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func selectBalance(by id: Int) {
        guard let balanceIndex = input.balances.firstIndex(where: { $0.balance?.id?.int == id }) else { return }
        let itemIndex = IndexPath(item: balanceIndex, section: 0)
        
        self.collection.isPagingEnabled = false
        self.collection.scrollToItem(at: itemIndex, at: .centeredHorizontally, animated: true)
        self.collection.isPagingEnabled = true
    }
    
    public func setCards(data: BillingEntitiesData, completion: @escaping () -> Void) {
        input.balances = data.collection ?? []
        output.balanceCollectionItem = input.balances.first
        collection.reloadData(completion: completion)
    }
    
    public func updateSkeleton(isLoading: Bool) {
        input.balancesSkeleton.isAnimating = isLoading
        collection.reloadData()
    }
    
}
