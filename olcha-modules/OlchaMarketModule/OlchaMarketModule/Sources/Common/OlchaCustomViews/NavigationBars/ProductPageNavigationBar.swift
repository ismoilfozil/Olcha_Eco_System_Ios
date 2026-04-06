//
//  ProductPageNavigationBar.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 21/07/22.
//
import OlchaUI
import UIKit
class ProductPageNavigationBar: UIView {
    
    let backButton = IconButton()
    let likeButton = IconButton()
    let compareButton = IconButton()
    let shareButton = IconButton()
    let ratingButton = IconButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        self.addSubview(backButton)
        self.addSubview(likeButton)
        self.addSubview(compareButton)
        self.addSubview(shareButton)
        self.addSubview(ratingButton)
        
    }
    private func autolayout() {
        self.backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        self.likeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        self.compareButton.snp.makeConstraints { make in
            make.right.equalTo(self.likeButton.snp.left).inset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        self.shareButton.snp.makeConstraints { make in
            make.right.equalTo(self.compareButton.snp.left).inset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        self.ratingButton.snp.makeConstraints { make in
            make.right.equalTo(self.shareButton.snp.left).inset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        
    }
    private func configureViews() {
        self.backButton.setIcon(.left_anchor)
        self.likeButton.setIcon(.like_heart)
        self.shareButton.setIcon(.share)
        self.compareButton.setIcon(.compare)
        self.ratingButton.setIcon(.rating)
        
    }
    
}
