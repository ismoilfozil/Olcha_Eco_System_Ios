//
//  Separator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/07/22.
//

import UIKit
import OlchaUI
class Separator: BaseTableCell {

    private let separator = UIView()
    
    override func setupViews() {
        container.addSubview(separator)
    }
    
    override func autolayout() {
        self.separator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
        }
    }
    
    override func configureViews() {
        self.separator.backgroundColor = .olchaLightNeutralGray
        self.separator.round(0.5)
    }
    
    
}
