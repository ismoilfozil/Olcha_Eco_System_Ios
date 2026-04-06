//
//  HomeNewsItem.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 03/02/23.
//

import UIKit
import OlchaUI
public class HomeNewsItem: BaseCollectionCell {
    
    private lazy var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.round()
        return imageView
    }()
    
    public override func setupViews() {
        container.addSubview(newsImageView)
    }
    
    public override func autolayout() {
        newsImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        container.round()
        makeSkeleton(views: [
            container
        ])
    }
    
    public func setup(with data: NewsModel) {
        newsImageView.load(from: data.getMainImage())
    }
}
