//
//  NewsListItem.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 16/02/23.
//

import UIKit
import OlchaUI
import Kingfisher
public class NewsListItem: BaseCollectionCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public lazy var button: IButton = {
        let button = IButton()
        return button
    }()
    
    public override func setupViews() {
        container.addSubview(imageView)
        container.addSubview(button)
    }
    
    public override func autolayout() {
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        container.round(16)
        container.border(with: .lightGrayBackground1)
    }
    
    func setup(_ model: NewsModel) {
        imageView.load(from: model.getMainImage(), contentMode: .scaleAspectFill)
    }
}
