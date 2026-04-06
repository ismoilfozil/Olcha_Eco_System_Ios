//
//  PaymentTypeHeader.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 12/02/23.
//

import UIKit
import OlchaUI
class PaymentTypeHeader: UITableViewHeaderFooterView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 24)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        autolayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(titleLabel)
    }
    
    func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(12)
        }
    }
    
    func setup(title: String?) {
        titleLabel.text = title
    }
}
