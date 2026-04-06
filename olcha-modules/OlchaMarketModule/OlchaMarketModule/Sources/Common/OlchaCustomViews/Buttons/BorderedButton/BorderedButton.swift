//
//  BorderedButton.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 11/11/22.
//


import UIKit
import OlchaUI

open class BorderedButton: BaseView {
    public let container = UIView()
    public let titleLabel = UILabel()
    public let settings = IButton()
    
    private var buttonClickListener: (() -> ())?
    
    public var horizontalInset: CGFloat = 16 {
        didSet {
            updateLayout()
        }
    }
    
    public var verticalInset: CGFloat = 6 {
        didSet {
            updateLayout()
        }
    }
    
    public var backColor: UIColor? = .olchaWhite {
        didSet {
            container.backgroundColor = backColor
            container.darkBorder(with: backColor)
        }
    }
    
    public var titleColor: UIColor? = .olchaTextBlack {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    override public func setupViews() {
        addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(settings)
    }
    
    override public func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        settings.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        updateLayout()
    }
    
    override public func configureViews() {
        container.backgroundColor = .olchaWhite
        container.round(8)
        container.darkBorder()
        titleLabel.style(.medium, 14)
        titleLabel.textColor = titleColor
        titleLabel.textAlignment = .center
        
        settings.clicked { [weak self] in
            guard let self = self else { return }
            self.buttonClickListener?()
        }
    }
    
    private func updateLayout() {
        titleLabel.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(horizontalInset)
            make.top.bottom.equalToSuperview().inset(verticalInset)
        }
    }

    public func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    public func clicked(_ listener: @escaping () -> Void ) {
        self.buttonClickListener = listener
    }
    
}

