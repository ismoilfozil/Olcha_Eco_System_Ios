//
//  RightIconButton.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 01/07/22.
//


import UIKit
import SnapKit
#warning("See all")
public class RightIconButton: UIView {
    
    public let buttonTitle = UILabel()
    private let icon = UIImageView()
    public let settings = IButton()
    
    var textColor: UIColor? = .olchaAccentColor {
        didSet {
            buttonTitle.textColor = textColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(buttonTitle)
        addSubview(icon)
        addSubview(settings)
        
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.centerY.equalToSuperview()
            make.left.equalTo(buttonTitle.snp.right).inset(-4)
        }
        
        buttonTitle.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        
        settings.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        buttonTitle.style(.semibold, 13)
        buttonTitle.textColor = .olchaAccentColor
    }
    
    public func configure(image: UIImage?,
                          title: String,
                          size: CGFloat = 24.0,
                          padding: CGFloat = 0) {
        if let image = image {
            self.icon.image = image
            
            icon.snp.remakeConstraints { make in
                make.width.height.equalTo(size)
                make.right.equalToSuperview().inset(padding)
                make.centerY.equalToSuperview()
                make.left.equalTo(buttonTitle.snp.right).inset(-4)
            }
            
        } else {
            icon.snp.remakeConstraints { make in
                make.width.height.equalTo(0)
                make.right.centerY.equalToSuperview()
                make.left.equalTo(buttonTitle.snp.right).inset(-padding)
            }
        }
        
        buttonTitle.text = title
        
        
        buttonTitle.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(padding)
        }
    }
    
    
    func designSeeAll() {
//        configure(image: .rightIcon, title: "all".localized().uppercased())
    }
    
}
