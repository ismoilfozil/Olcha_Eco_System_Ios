//
//  GuestCartNavigationBar.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 29/01/24.
//

import UIKit
import OlchaUI

class GuestCartNavigationBar: BaseView {
    
    private let container: UIView = {
        let view = UIView()
        view.round(12, topCorner: false, bottomCorner: true)
        view.backgroundColor = .olchaWhite
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    override func setupViews() {
        addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
    }
    
    override func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).inset(-6)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureViews() {
        backgroundColor = CartStyle.backgroundColor
    }
    
    func setup(count: Int) {
        titleLabel.text = "basket".localized()
        valueLabel.text = count.string + "products_count".localized()
    }
}

