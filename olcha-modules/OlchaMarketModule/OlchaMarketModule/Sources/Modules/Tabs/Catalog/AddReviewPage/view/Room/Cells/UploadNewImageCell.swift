//
//  UploadNewImageCell.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/08/22.
//

import UIKit
import OlchaUI
class UploadNewImageCell: BaseCollectionCell {
    
    private let icon = UIImageView()
    
    override func setupViews() {
        container.addSubview(icon)
    }
    
    override func autolayout() {
        horizontalEdge = 4
        verticalEdge = 4
        
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    override func configureViews() {
        container.round(8)
        container.darkBorder()
        
        icon.image = .camera
    }
}
