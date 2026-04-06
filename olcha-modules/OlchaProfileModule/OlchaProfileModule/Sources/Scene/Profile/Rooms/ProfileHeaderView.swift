//
//  ProfileHeaderView.swift
//  OlchaProfileModule
//
//  Created by Elbek Khasanov on 20/09/23.
//

import UIKit
import OlchaUI

class ProfileHeaderView: BaseView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaLightTextColornnnnnn
        label.numberOfLines = 0
        label.style(.medium, 16)
        return label
    }()

    
    override func setupViews() {
        addSubview(titleLabel)
    }
    
    override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    public func setup(with data: String?) {
        titleLabel.text = data
    }
}
