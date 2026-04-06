//
//  DotPictureRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/08/22.
//

import UIKit
import Combine
import OlchaUI
class DotPictureRoom: BaseTableCell {
    
    private let dotPicture = DotPictureView()
    
    weak var productHelper: ProductHelper? {
        didSet {
            dotPicture.productHelper = productHelper
        }
    }

    override func setupViews() {
        container.addSubview(dotPicture)
    }
    
    override func autolayout() {
        
        dotPicture.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(dotPicture.snp.width).multipliedBy(0.77)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
        }
        
    }
    
    override func configureViews() {
        dotPicture.imageView.contentMode = .scaleToFill
        dotPicture.round(8)
    }
    
    func setup(with data: ComponentDataModel?) {

        dotPicture.dots = data?.coordinates ?? []
        dotPicture.imageView.load(from: data?.getImageUrl(),
                                  imageType: .ignoreResize)
        
    }
    
    func tableScrolling() {
        dotPicture.hideAllPins()
    }
    
}
