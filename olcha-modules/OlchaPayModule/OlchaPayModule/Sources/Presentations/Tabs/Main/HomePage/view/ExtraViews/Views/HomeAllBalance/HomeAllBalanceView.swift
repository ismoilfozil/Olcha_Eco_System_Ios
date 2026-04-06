//
//  HomeAllBalanceView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 04/02/23.
//

import UIKit
import OlchaUI
public class HomeAllBalanceView: BaseView {
    private lazy var container: UIView = {
        let view = UIView()
        view.round()
        view.backgroundColor = .olchaWhite
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaDarkGray
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.style(.bold, 24)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(amountLabel)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(16)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
        }
    }
    
    public override func configureViews() {
        backgroundColor = .clear
        amountLabel.text = ( 0 ).string.originalPrice
    }
    
    public func setup(totalSum: Double?) {
        titleLabel.text = "all_balance".localized()
        amountLabel.text = totalSum?.string.originalPrice
    }
}
