//
//  PaymentGroupView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 03/02/23.
//

import UIKit
import OlchaUI
public class PaymentGroupView: BaseView {
    
    let collectionHeight: CGFloat = 116
    
    public lazy var header: GroupHeaderView = {
        let view = GroupHeaderView()
        return view
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: PaymentGroupItem.self)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    public var withBorder: Bool = false
    
    weak var observer: PushPaymentHelper?
    
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
    
    
    public func setupHeader(title: String) {
        header.set(title: title)
    }
    
    
}
