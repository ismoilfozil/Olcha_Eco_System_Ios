//
//  UploadImageCell.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/08/22.
//

import UIKit
import Combine
import OlchaUI
class UploadMediaCell: BaseCollectionCell {
    
    private let imageView = UIImageView()
    private let videoPlayImage = UIImageView()
    let removeButton = IconButton()
    
    var isVideo = false {
        didSet {
            videoPlayImage.isHidden = !isVideo
        }
    }
    
    var isUploading = false {
        didSet {
            observeIndicator(state: isUploading)
            removeButton.isHidden = isUploading
        }
    }
    
    override func setupViews() {
        container.addSubview(imageView)
        container.addSubview(videoPlayImage)
        container.addSubview(removeButton)
        container.addSubview(indicator)
    }
    
    override func autolayout() {
        horizontalEdge = 4
        verticalEdge = 4
        
        self.imageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.videoPlayImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        self.removeButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.top.right.equalToSuperview().inset(4)
        }
        
        self.indicator.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    override func configureViews() {
        
        self.container.backgroundColor = .clear
        self.container.round(8)
        self.container.border(with: .olchaLightNeutralGray)
        
        self.imageView.backgroundColor = .clear
        self.removeButton.setIcon(.remove_image)
        
        self.videoPlayImage.isHidden = true
        self.videoPlayImage.image = .play
        isUploading = false
    }
    
    func setup(with data: String?) {
        self.imageView.load(from: data)
    }

    func setup(image: UIImage?) {
        self.imageView.image = image
    }
    
}
