//
//  ProductOptionCell.swift
//  NewOlcha
//
//  Created by Muhammadjon on 1/31/21.
//  Updated by Elbek Khasanov on 21/07/22
//
import SnapKit
import UIKit
import OlchaUI
class ProductOptionCell: BaseCollectionCell {
    
    
    private let img = UIImageView()
    
    private let titleLabel = UILabel()
    private let alphaContainer = UIView()
    private let diagonalLine = DiagonalLine()
    var combinationState: CombinationState = .enabled
    
    var isPressed : Bool = false
    
    override func setupViews() {
        self.container.addSubview(img)
        self.container.addSubview(titleLabel)
        self.container.addSubview(alphaContainer)
        self.container.addSubview(diagonalLine)
    }
    
    override func autolayout() {
        
        self.img.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        self.titleLabel.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        self.alphaContainer.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        self.diagonalLine.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    override func configureViews() {
        self.container.round()
        self.container.border(width: 2)
        self.titleLabel.textColor = .olchaTextBlack
        self.titleLabel.clipsToBounds = true
        self.titleLabel.numberOfLines = 0
        self.titleLabel.style(.medium, 16)
        self.titleLabel.textAlignment = .center
        
        
        self.container.clipsToBounds = true
        
        
        self.alphaContainer.isHidden = true
        self.alphaContainer.backgroundColor = .white.withAlphaComponent(0.5)
        
        self.diagonalLine.isHidden = true
        
        
        self.img.isHidden = true
        self.titleLabel.isHidden = true
    }
    
    override func prepareForReuse() {
        self.img.image = nil
        self.titleLabel.text = nil
        self.combinationState = .enabled
        super.prepareForReuse()
    }
    
    
    func setDatas(data: VariationData) {
        self.img.image = nil
        self.titleLabel.text = nil
        
        if let imgUrl = data.images, !imgUrl.isEmpty {
            self.titleLabel.isHidden = true
            self.img.load(from: imgUrl,
                          transition: false,
                          imageType: .equalSize(OptionsCell.imageSize)
            )
            self.img.isHidden = false
        } else {
            self.titleLabel.isHidden = false
            self.img.isHidden = true
            self.titleLabel.text = data.getFeatureValueName()
            self.titleLabel.sizeToFit()
        }
        
        if data.active {
            self.selectedStyle()
        } else {
            self.unSelectedStyle()
        }
        
        self.autolayout()
    }
    
    func selectedStyle() {
        self.alphaContainer.isHidden = true
        if self.img.isHidden {
            self.titleLabel.textColor = .olchaWhite
            self.container.backgroundColor = .olchaTextBlack
            self.container.layer.borderColor = UIColor.olchaTextBlack.cgColor
        } else {
            self.container.backgroundColor = .olchaWhite
            self.container.layer.borderColor = UIColor.olchaAccentColor.cgColor
        }
    }
    
    func unSelectedStyle() {
        self.container.layer.borderColor = UIColor.olchaTextBlack.cgColor
        self.container.backgroundColor = .olchaWhite
        self.titleLabel.textColor = .olchaTextBlack
    }
    
    func emptyStyle() {
        self.container.layer.borderColor = UIColor.olchaLightNeutralDarkGray?.cgColor
        self.container.backgroundColor = .olchaWhite
        self.titleLabel.textColor = .olchaTextBlack
    }
    
    func track(state: CombinationState, isActive: Bool) {
        self.combinationState = state
        self.container.layer.borderColor = UIColor.olchaTextBlack.cgColor
        switch state {
        case .enabled:
            self.alphaContainer.isHidden = true
            self.diagonalLine.isHidden = true
            if isActive { selectedStyle() }
        case .disabled:
            self.alphaContainer.isHidden = false
            self.diagonalLine.isHidden = false
            if isActive { selectedStyle() }
        case .none:
            self.alphaContainer.isHidden = false
            self.diagonalLine.isHidden = true
            if isActive { selectedStyle() }
        }
        
    }
    
}
