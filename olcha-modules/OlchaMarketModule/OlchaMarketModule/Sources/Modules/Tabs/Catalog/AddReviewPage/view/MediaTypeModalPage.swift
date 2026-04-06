//
//  MediaTypeModalPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/08/22.
//

import UIKit
import OlchaUI

class MediaTypeModalPage: BaseViewController, ModalPageType {
    
    private let galleryButton = LeftIconButton()
    private let separator = Divide()
    private let cameraButton = LeftIconButton()
    
    var mediaClicked: ((UIImagePickerController.SourceType) -> Void )?
    
    
    override func viewDidLoad() {
        
        setupModalViews()
        modalAutolayout()
        configureModalViews(header: "select_photo".localized())
        setupObservers()
        
    }
    
    override func setupModalViews() {
        super.setupModalViews()
        modalContainer.addSubview(galleryButton)
        modalContainer.addSubview(separator)
        modalContainer.addSubview(cameraButton)
    }
    
    override func modalAutolayout() {
        super.modalAutolayout()
        galleryButton.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(56)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(galleryButton.snp.bottom)
            make.bottom.equalTo(cameraButton.snp.top)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(56)
        }
    }
    
    override func configureModalViews(header: String = "", textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: header, textAlignment: textAlignment)
        dismissConfiguration()
        galleryButton.setIcon(.gallery)
        galleryButton.setTitle("gallery".localized())
        cameraButton.setIcon(.camera_simple)
        cameraButton.setTitle("camera".localized())
        galleryButton.enableContainer()
        cameraButton.enableContainer()
    }
    
    override func setupObservers() {
        galleryButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.mediaClicked?(.photoLibrary)
        }
        
        cameraButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.mediaClicked?(.camera)
        }
    }
  
}
