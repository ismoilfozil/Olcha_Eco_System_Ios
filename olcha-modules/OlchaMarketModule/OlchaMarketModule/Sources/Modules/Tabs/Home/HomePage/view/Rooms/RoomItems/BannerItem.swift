//
//  BannerItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//
import SkeletonView
import UIKit
import OlchaUI
import SnapKit
class BannerItem: BaseCollectionCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        skeletonViews.forEach({ $0.layoutSkeletonIfNeeded() })
    }
    
    override func setupViews() {
        container.addSubview(imageView)
    }
    
    override func configureViews() {
        container.round()
        container.backgroundColor = .lightGrayBackground
        makeSkeleton(views: [container])
        
    }
    
    override func autolayout() {
        
        
        imageView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    
    func setup(with data: Slider) {

        let url: String = data.getImage()
        imageView.load(from: url, transition: false)
        
    }
    
    func setupFlagmans(with data: Slider) {
        let url: String = data.getMobileImage()
        imageView.load(from: url)
    }
    
}
