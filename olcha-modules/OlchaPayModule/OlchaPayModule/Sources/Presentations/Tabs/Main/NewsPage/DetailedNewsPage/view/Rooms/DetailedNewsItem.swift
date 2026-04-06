//
//  DetailedNewsItem.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 16/02/23.
//

import UIKit
import OlchaUI
class DetailedNewsItem: BaseCollectionCell {
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.container.spacing = 16
        scrollView.settings.contentInset = .init(top: 0, left: 0, bottom: 32, right: 0)
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .mock_click
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.style(.bold, 24)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.settings.setContentOffset(.zero, animated: false)
    }
    
    override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(imageView)
        scrollView.addArrangedSubview(headerLabel)
        scrollView.addArrangedSubview(contentLabel)
    }
    
    override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        contentView.backgroundColor = .olchaWhite
    }
    
    func setup(with data: NewsModel) {
        headerLabel.text = data.getTitle()
        contentLabel.text = data.getDescription()
        imageView.load(from: data.getMainImage())
    }
}
