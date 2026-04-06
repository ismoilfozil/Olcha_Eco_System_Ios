//
//  ProductImageView.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 03/01/24.
//

import UIKit
import OlchaUI
class ProductImageView: BaseView {
    
    let settings = UIImageView()
    let adultChecker = AdultChecker()
    
    override func setupViews() {
        addSubview(settings)
        addSubview(adultChecker)
    }
    
    override func autolayout() {
        settings.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        adultChecker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
