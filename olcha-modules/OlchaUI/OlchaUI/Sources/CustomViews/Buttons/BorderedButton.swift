//
//  BorderedButton.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 11/11/22.
//


import UIKit
public class BorderedButton: UIView {
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
    
    public var titleColor: UIColor? = .olchaTextBlack {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    public var borderColor: UIColor? = .olchaTextBlack {
        didSet {
            container.border(with: borderColor, width: borderWidth)
        }
    }
    
    public var borderWidth: CGFloat = 1 {
        didSet {
            container.border(with: borderColor, width: borderWidth)
        }
    }
    
    public var cornerRadius: CGFloat = 8 {
        didSet {
            container.round(8)
        }
    }
    
    public var background: UIColor? = .olchaWhite {
        didSet {
            container.backgroundColor = background
        }
    }
    
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
        addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(settings)
    }
    
    private func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        settings.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        updateLayout()
    }
    
    private func configureViews() {
        container.backgroundColor = background
        container.round(cornerRadius)
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

