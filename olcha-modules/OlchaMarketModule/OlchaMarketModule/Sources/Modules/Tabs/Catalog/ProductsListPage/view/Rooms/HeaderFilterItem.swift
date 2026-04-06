//
//  HeaderFilterItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/07/22.
//

import UIKit
import OlchaUI
class HeaderFilterItem: BaseCollectionCell {
    let filter = HeaderFilterButton()
    
    override func setupViews() {
        container.addSubview(filter)
    }
    
    override func autolayout() {
        container.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.height.equalTo(32)
        }
        
        filter.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(6)
            make.top.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        filter.unselectedStyle()
    }
    
    func setup(data: FeatureData?) {
        let title: String = data?.getName() ?? ""
        filter.setTitle(title)
    }
    
    func setup(title: String) {
        filter.setTitle(title)
    }
    
    func checkStatus(_ enabled: Bool) {
        enabled ? filter.selectedStyle() : filter.unselectedStyle()
    }
}
