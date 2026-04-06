//
//  TransactionStatusView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 21/09/23.
//

import OlchaUI
import UIKit

public class TransactionStatusView: BaseView {
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 8)
        label.textAlignment = .center
        return label
    }()
    
    public override func setupViews() {
        addSubview(titleLabel)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(6)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }
    
    public override func configureViews() {
        round(4)
    }
    
    public func setup(title: String?) {
        titleLabel.text = title ?? " - "
    }
    
    public func setup(color: UIColor? = .olchaLightTextColornnnnnn) {
        backgroundColor = color?.withAlphaComponent(0.1)
        titleLabel.textColor = color
    }
}
