//
//  HorizontalButton.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 30/01/24.
//

import UIKit
public class HorizontalButton: BaseView {
    public let container: UIStackView = {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 8
        container.alignment = .center
        return container
    }()
    
    public let leftButton: IconButton = {
        let imageView = IconButton()
        imageView.isHidden = true
        return imageView
    }()
    
    public let rightButton: IconButton = {
        let imageView = IconButton()
        imageView.isHidden = true
        return imageView
    }()
    
    public let settings: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.style(.medium, 12)
        return label
    }()
    
    public let button = IButton()
    
    public var leftIconSize: CGFloat = 16 {
        didSet {
            leftButton.snp.remakeConstraints { make in
                make.width.height.equalTo(leftIconSize)
            }
        }
    }
    
    public var rightIconSize: CGFloat = 16 {
        didSet {
            rightButton.snp.remakeConstraints { make in
                make.width.height.equalTo(rightIconSize)
            }
        }
    }
    
    public var spacing: CGFloat = 8 {
        didSet {
            container.spacing = spacing
        }
    }
    
    public var text: String? = "" {
        didSet {
            settings.text = text
        }
    }
    
    private var completion: (() -> Void)?
    
    public var isButtonEnabled: Bool = true {
        didSet {
            button.isUserInteractionEnabled = isButtonEnabled
            leftButton.isUserInteractionEnabled = isButtonEnabled
            rightButton.isUserInteractionEnabled = isButtonEnabled
        }
    }
    
    public override func setupViews() {
        addSubview(container)
        container.addArrangedSubview(leftButton)
        container.addArrangedSubview(settings)
        container.addArrangedSubview(rightButton)
        addSubview(button)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        settings.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        leftIconSize = 16
        rightIconSize = 16
    }
    
    public override func configureViews() {
        button.clicked { [weak self] in
            guard let self else { return }
            completion?()
        }
    }
    
    public func setup(leftIcon: UIImage? = nil) {
        leftButton.setIcon(leftIcon)
        leftButton.isHidden = (leftIcon == nil)
    }
    
    public func setup(rightIcon: UIImage? = nil) {
        rightButton.setIcon(rightIcon)
        rightButton.isHidden = (rightIcon == nil)
    }
    
    public func clicked(_ completion: (() -> Void)?) {
        self.completion = completion
    }
    
}
