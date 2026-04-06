//
//  SavedTransactionsGroupView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 31/03/23.
//

import Foundation
import UIKit
import OlchaUI
public class SavedTransactionsGroupView: BaseView {
    
    let collectionHeight: CGFloat = 116
    
    public lazy var header: GroupHeaderView = {
        let view = GroupHeaderView()
        return view
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: SavedTransactionItem.self)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    public var items: [SavedTransactionModel] = [] {
        didSet {
            collection.reloadData()
        }
    }
    
    var observer: ((SavedTransactionModel?) -> Void)?
    
    let skeleton = Skeleton(count: 12)
    
    public override func setupViews() {
        addSubview(header)
        addSubview(collection)
    }
    
    public override func autolayout() {
        header.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.right.equalToSuperview()
        }
        
        collection.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.left.right.equalToSuperview()
            make.top.equalTo(header.snp.bottom).inset(-8)
            make.height.equalTo(collectionHeight)
        }
    }
    
    public override func configureViews() {
//        header.isSkeletonable = true
//        header.isHiddenWhenSkeletonIsActive = true
    }
    
    public func setupHeader(title: String) {
        header.set(title: title)
    }
    
    public func setup(data: [SavedTransactionModel]) {
        self.items = data
        self.isHidden = data.isEmpty
    }
    
    public func resetData() {
        self.isHidden = false
        self.items = []
    }
    
    public func clickObserver( _ observer: @escaping (SavedTransactionModel?) -> Void) {
        self.observer = observer
    }
    
    public override func languageUpdated() {
        collection.reloadData()
        setupHeader(title: "saved_transactions".localized())
    }
    
    public func reloadData() {
        skeleton.isAnimating ? header.showGradientSkeleton() : header.stopSkeletonAnimation()
        collection.reloadData()
    }
}
