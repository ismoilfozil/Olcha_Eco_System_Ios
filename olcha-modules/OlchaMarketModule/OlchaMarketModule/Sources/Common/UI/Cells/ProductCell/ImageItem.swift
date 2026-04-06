//
//  ImageItem.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 11/10/23.
//

import UIKit
import OlchaUI
public class ImageItem: BaseCollectionCell {
    
    private let backgroundImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let alphaContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .productAlphaColor.withAlphaComponent(0.04)
        return view
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImageView.image = nil
        contentImageView.image = nil
    }
    
    public override func setupViews() {
        container.addSubview(backgroundImageView)
        container.addSubview(contentImageView)
        container.addSubview(alphaContainer)
    }
    
    public override func autolayout() {
        container.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(contentImageView.snp.width)
        }
        
        alphaContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func setup(isWhite: Bool,
                      urlString: String?) {
        
        contentImageView.isHidden = !isWhite
        backgroundImageView.isHidden = isWhite
        isWhite ? setup(content: urlString) : setup(background: urlString)
    }
    
    private func setup(background: String?) {
        contentImageView.image = nil
        backgroundImageView.load(from: background,
                                 quality: 4,
                                 imageType: .flexible)
    }
    
    private func setup(content: String?) {
        backgroundImageView.image = nil
        contentImageView.load(from: content,
                              quality: 4,
                              imageType: .flexible,
                              contentMode: .scaleAspectFit)
    }
}
