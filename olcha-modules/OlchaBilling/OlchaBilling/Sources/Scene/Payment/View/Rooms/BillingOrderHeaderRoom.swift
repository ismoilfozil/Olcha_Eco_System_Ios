//
//  BillingOrderHeaderRoom.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 20/06/23.
//

import UIKit
import OlchaUI
public class BillingOrderHeaderRoom: BaseCollectionCell {
    
    private let orderTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        label.text = " - "
        label.numberOfLines = 0
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.text = " - "
        label.numberOfLines = 0
        return label
    }()
    
    public override func setupViews() {
        container.addSubview(orderTitleLabel)
        container.addSubview(amountLabel)
    }
    
    public override func autolayout() {
        container.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        orderTitleLabel.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.top.equalToSuperview().inset(16)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(orderTitleLabel.snp.left)
            make.right.equalTo(orderTitleLabel.snp.right)
            make.bottom.equalToSuperview().inset(16)
            make.top.equalTo(orderTitleLabel.snp.bottom).inset(-4)
        }
    }
    
    public func setup(id: Int?, amount: Int?) {
        orderTitleLabel.text = "order_num".localized(.billing) + " : " + (id?.string ?? "")
        amountLabel.text = amount?.string.originalPrice
    }
    
}
