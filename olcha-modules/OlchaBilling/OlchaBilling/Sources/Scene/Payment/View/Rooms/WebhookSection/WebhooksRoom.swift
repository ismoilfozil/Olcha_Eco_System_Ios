//
//  WebhooksRoom.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 02/08/23.
//

import UIKit
import OlchaUI
import Combine
import OlchaUtils

public class WebhooksRoom: BaseTableCell {

    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.registerClass(forCell: BillingPaymentItem.self)
        collection.delegate = self
        collection.dataSource = self
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()
    
    public var webhooks: [BillingPayment] = [] {
        didSet {
            collection.reloadSections(.init(integer: 0))
        }
    }
    
    public var selectObserver: ((BillingPayment) -> Void)?
    
    public var selectedPayment: BilllingPaymentModel?
    
    weak var skeleton: Skeleton?
    
    public override func setupViews() {
        container.addSubview(collection)
    }
    
    public override func autolayout() {
        collection.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    public func setup(with data: [BillingPayment]) {
        self.webhooks = data
    }
}
