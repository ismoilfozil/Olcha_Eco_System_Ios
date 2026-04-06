//
//  PaymentTypesRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/10/22.
//

import UIKit
import OlchaUtils
import OlchaUI

class PaymentTypesRoom: BaseTableCell {
    
    private let titleLabel = UILabel()
    
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var paymentTypesData: PaymentTypeData?
    
    var payments: [Payments] = []
    var paymentSystems: [Payments] = []
    
    let paymentHeight: CGFloat = 130
    let paymentSystemHeight: CGFloat = 78
    
    weak var observers: CartObservers?
    
    var selectedPayment: Payments?
    
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
        collection.registerClass(forCell: PaymentIconItem.self)
        collection.isScrollEnabled = false
        
        if let layout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 0
            collection.collectionViewLayout = layout
        }
    }
    
    func setup(with data: PaymentTypeData?, selectedPayment: Payments?) {
        titleLabel.text = "payment_type".localized()
        self.payments = data?.payments ?? []
        self.paymentSystems = data?.paymentSystems ?? []
        self.selectedPayment = selectedPayment
        updateLayout()
    }
    
    private func updateLayout() {
        collection.reloadData()
        collection.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.height.equalTo(calculateHeight())
        }
    }
    
    private func calculateHeight() -> CGFloat {
        var height: CGFloat = paymentHeight * payments.count.cgfloat
        height += paymentSystemHeight * (paymentSystems.count.cgfloat / 2.0).rounded(.up)
        return height
    }
}
