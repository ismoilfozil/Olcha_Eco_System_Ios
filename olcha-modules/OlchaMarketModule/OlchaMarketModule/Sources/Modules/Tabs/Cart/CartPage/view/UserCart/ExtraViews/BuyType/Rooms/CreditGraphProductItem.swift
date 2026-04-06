//
//  CreditGraphProductItem.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 21/02/24.
//

import UIKit
import OlchaUI

class CreditGraphProductItem: BaseCollectionCell {
    
    private let imageViewContainer: UIView = {
        let view = UIView()
        view.round(8)
        view.backgroundColor = .olchaLightGray
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    override func setupViews() {
        container.addSubview(imageViewContainer)
        imageViewContainer.addSubview(imageView)
    }
    
    override func autolayout() {
        imageViewContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
    
}
