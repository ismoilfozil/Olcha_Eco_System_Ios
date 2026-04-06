//
//  ProductPictureCell.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/07/22.
//

import UIKit
import OlchaUI
class ProductPictureCell: BaseCollectionCell {

    
    let imageView = UIImageView()
    
    override func setupViews() {
        
        container.addSubview(imageView)
    }
    
    override func autolayout() {
        
        imageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        container.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
    }
    
    func setup(with data: String) {
        imageView.load(from: data,
                       imageType: .quadratic,
                       contentMode: .scaleAspectFit)
    }

}
