//
//  BigBannerCell.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/09/22.
//

import UIKit
import OlchaUI
class BigBannerCell: BaseCollectionCell {

    private let imageView = UIImageView()
    
    override func prepareForReuse() {
        imageView.image = nil
        super.prepareForReuse()
    }
    
    override func setupViews() {
        container.addSubview(imageView)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 16
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        container.backgroundColor = .lightGrayBackground
        container.round()
        
    }
    
    func setup(with data: String) {
        imageView.load(from: data)
    }
    
    
}
