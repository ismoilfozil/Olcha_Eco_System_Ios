//
//  VerificationPhotoView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 24/11/22.
//

import OlchaUI
import UIKit
public class VerificationPhotoView: UIView {
    
    private let imageContainer = UIView()
    public let imageView = UIImageView()
    public let titleLabel = UILabel()
    public let cameraButton = LeftIconButton()
    public let galleryButton = LeftIconButton()
    
    public var loading: Bool = false {
        didSet {
            loading ? imageContainer.showAnimatedGradientSkeleton() : imageContainer.hideSkeleton()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        autolayout()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        imageContainer.layoutSkeletonIfNeeded()
    }
    
    private func setupViews() {
        addSubview(imageContainer)
        
        imageContainer.addSubview(imageView)
        addSubview(titleLabel)
        addSubview(cameraButton)
        addSubview(galleryButton)
    }
    
    private func autolayout() {
        
        
        imageContainer.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
            make.width.equalTo(112)
            make.height.equalTo(80)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.left.right.equalToSuperview().inset(19)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(16)
            make.left.equalTo(imageContainer.snp.right).inset(-12)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(36)
            make.top.equalTo(titleLabel.snp.bottom).inset(-16)
        }
        
        galleryButton.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(36)
            make.top.equalTo(cameraButton.snp.bottom).inset(-8)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func configureViews() {
        
        round()
        backgroundColor = .lightGrayBackground
        
        imageContainer.isSkeletonable = true
        imageContainer.backgroundColor = .olchaLightBlue
        imageContainer.round(8)
        
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.numberOfLines = 0
        titleLabel.style(.semibold, 16)
        titleLabel.textColor = .olchaTextBlack
        
        cameraButton.backgroundColor = .olchaAccentColor
        cameraButton.titleLabel.textColor = .olchaWhite
        cameraButton.setIcon(.camera_white, iconSize: 20)
        cameraButton.round(8)
        cameraButton.enableContainer()
        cameraButton.setTitle("take_picture".localized())
        
        galleryButton.backgroundColor = .olchaWhite
        galleryButton.titleLabel.textColor = .olchaTextBlack
        galleryButton.darkBorder()
        galleryButton.round(8)
        galleryButton.setIcon(.upload, iconSize: 20)
        galleryButton.setTitle("load_picture".localized())
        galleryButton.enableContainer()
    }
}
