//
//  NasiyaBannerItem.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import UIKit
import OlchaUI
class NasiyaBannerItem: BaseCollectionCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .olchaLightTextColornnnnnn
        imageView.round(16)
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func setupViews() {
        container.addSubview(imageView)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        container.round(16)
        makeSkeleton(views: [
            container
        ])
    }
    
    func setup(url: String?) {
        imageView.image = nil
        imageView.load(from: url, transition: false)
    }
}
