//
//  CreditGraphPaymentItem.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 21/02/24.
//

import UIKit
import OlchaUI

class CreditGraphPaymentItem: BaseCollectionCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 10)
        label.textAlignment = .center
        label.textColor = .olchaTextBlack
        return label
    }()
    
    override func setupViews() {
        container.addSubview(titleLabel)
    }
    
    override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setup(title: String?) {
        titleLabel.text = title
    }
    
}
