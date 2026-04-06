//
//  BackgroundedImage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 09/08/22.
//

import UIKit
import OlchaUI
class BackgroundedImage: BaseCollectionCell {

    private let backgroundImageView = UIImageView()
    private let mainImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override func prepareForReuse() {
        mainImageView.image = nil
        backgroundImageView.image = nil
        super.prepareForReuse()
    }
    
    override func setupViews() {
        container.addSubview(backgroundImageView)
        container.addSubview(mainImageView)
        container.addSubview(titleLabel)
    }
    
    override func autolayout() {
        horizontalEdge = 8
        verticalEdge = 8
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(backgroundImageView.snp.width)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.edges.equalTo(backgroundImageView.snp.edges).inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom).inset(-4)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        backgroundImageView.round()
        backgroundImageView.backgroundColor = .olchaLightNeutralDarkGray
        backgroundImageView.contentMode = .scaleToFill
        
        titleLabel.style(.medium, 12)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.text = ""
    }
    
    func setup(background: String?,
               main: String?,
               title: String = ""
    ) {
        titleLabel.text = title
        backgroundImageView.load(from: background,
                                 withIndicator: false,
                                 imageType: .quadratic)
        
        mainImageView.load(from: main,
                           imageType: .quadratic)
        
    }
    
}
