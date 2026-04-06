//
//  CorneredImage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/07/22.
//

import UIKit
import SwiftUI
import OlchaUI
class CorneredImage: BaseCollectionCell {
    private let imageView = UIImageView()
    
    private let countLabel = UILabel()
    
    var cornerRadius: CGFloat = 8 {
        didSet {
            self.container.round(cornerRadius)
            self.imageView.round(cornerRadius)
        }
    }
    
    var selectedStyle: Bool = false {
        didSet {
            container.border(with: .olchaAccentColor, width: selectedStyle ? 2 : 0)
        }
    }
    
    var imageContentMode: UIView.ContentMode = .scaleToFill {
        didSet {
            imageView.contentMode = contentMode
        }
    }
    
    override func setupViews() {
        self.container.addSubview(imageView)
        self.container.addSubview(countLabel)
    }
    
    override func autolayout() {
        horizontalEdge = 4
        verticalEdge = 4
        
        self.imageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.countLabel.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        self.container.clipsToBounds = true
        self.container.backgroundColor = .clear
        self.imageView.backgroundColor = .clear
        self.container.round(cornerRadius)
        self.countLabel.backgroundColor = .olchaWhite.withAlphaComponent(0.7)
        self.countLabel.style(.semibold, 16)
        self.countLabel.textColor = .olchaTextBlack
        self.countLabel.isHidden = true
        self.countLabel.textAlignment = .center
    }
    
    func setup(with data: String?) {
        self.imageView.load(from: data)
    }
    
    func setup(image: UIImage?) {
        self.imageView.image = image
    }
    
    func setImagesCount(isLast: Bool, count: Int) {
        self.countLabel.text = "+" + count.string
        self.countLabel.isHidden = !isLast
    }
}
