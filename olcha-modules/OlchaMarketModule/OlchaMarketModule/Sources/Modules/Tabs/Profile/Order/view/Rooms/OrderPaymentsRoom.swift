//
//  OrderPaymentsRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 24/10/22.
//

import UIKit
import OlchaUI
import OlchaBankCards
import OlchaUtils
class OrderPaymentsRoom: BaseTableCell {
    
    private let titleLabel = UILabel()
    
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    var payments: [Payments] = []
    
    var bankCards: [BankCard] = []
    
    var balance: Balance?
    
    let paymentHeight: CGFloat = 130
    let paymentSystemHeight: CGFloat = 78
    
    weak var observer: OrderPaymentObserver?
    
    enum Section {
        case balance
        case card
        case payments
    }
    
    let sections: [Section] = [
        .balance,
        .card,
        .payments
    ]
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(collection)
    }
    
    override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.height.equalTo(0)
        }
    }
    
    override func configureViews() {
        titleLabel.style(.semibold, 24)
        titleLabel.textColor = .olchaTextBlack
        
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .olchaBackgroundColor
        collection.registerClass(forCell: PaymentTitleItem.self)
        collection.registerClass(forCell: PaymentIconItem.self)
    
        collection.isScrollEnabled = false
        
        if let layout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 0
            collection.collectionViewLayout = layout
        }
    }
    
    func setup(payments: [Payments], bankCards: [BankCard], balance: Balance?) {
        titleLabel.text = "payment_type".localized()
        
        self.payments = payments
        self.balance = balance
        self.bankCards = bankCards
        
        updateLayout()
    }
    
    private func updateLayout() {
        collection.reloadData()
        collection.snp.updateConstraints { make in
            make.height.equalTo(calculateHeight())
        }
    }
    
    private func calculateHeight() -> CGFloat {
        var height: CGFloat = (balance != nil) ? paymentHeight : 0
        height += (bankCards.count.cgfloat * paymentHeight)
        height += paymentSystemHeight * (payments.count.cgfloat / 2.0).rounded(.up)
        return height
    }

    
}
