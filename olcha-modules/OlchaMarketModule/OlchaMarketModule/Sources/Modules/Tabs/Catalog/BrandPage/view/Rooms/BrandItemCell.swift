//
//  BrandItemCell.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 31/08/22.
//

import UIKit
import OlchaUI
class BrandItemCell: BaseCollectionCell {
    private let imageView = UIImageView()
    
    
    override func prepareForReuse() {
        imageView.image = nil
        super.prepareForReuse()
    }
    
    override func setupViews() {
        container.addSubview(imageView)
    }
    
    override func autolayout() {
        horizontalEdge = 8
        verticalEdge = 8
        
        
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    override func configureViews() {
        container.round()
        container.border(with: .grayBorder)
    }
    
    func setup(with url: String?) {
        imageView.load(from: url)
    }
    
}
