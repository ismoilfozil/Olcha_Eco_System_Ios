//
//  OlchaButton.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/08/22.
//


import UIKit
open class OlchaButton: BaseView {
    
    public enum OlchaButtonType {
        case olcha
        case pay
        
        var height: CGFloat {
            switch self {
            case .olcha:
                return 40
            case .pay:
                return 48
            }
        }
    }
    
    public let settings = IButton()
    
    private var buttonClickListener: (() -> ())?
    
    private var disableButtonClickListener: (() -> ())?
    
    public let disableSettings: IButton = {
        let button = IButton()
        button.isUserInteractionEnabled = false
        button.backgroundColor = .clear
        return button
    }()
    
    open override func setupViews() {
        addSubview(settings)
        addSubview(disableSettings)
    }
    
    open override func autolayout() {
        settings.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        
        disableSettings.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    open override func configureViews() {
        settings.backgroundColor = .olchaAccentColor
        settings.setTitleColor(.olchaWhite, for: .normal)
        settings.round()
        settings.titleLabel?.style(.medium, 16)
        settings.contentEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 12)
        settings.clicked { [weak self] in
            guard let self = self else { return }
            self.buttonClickListener?()
        }
        
        disableSettings.clicked { [weak self] in
            guard let self else { return }
            disableButtonClickListener?()
        }
    }
    
    public func setTitle(_ text: String) {
        settings.setTitle(text, for: .normal)
    }
 
    public func enableButton() {
        guard !settings.requesting else { return }
        settings.backgroundColor = .olchaAccentColor
        settings.isEnabled = true
        disableSettings.isUserInteractionEnabled = false
    }
    
    public func disableButton() {
        guard !settings.requesting else { return }
        settings.backgroundColor = .olchaAccentColor.withAlphaComponent(0.4)
        settings.isEnabled = false
        disableSettings.isUserInteractionEnabled = true
    }
    
    public func clicked(_ listener: @escaping () -> Void, disableListener: (() -> Void)? = nil) {
        self.buttonClickListener = listener
        self.disableButtonClickListener = disableListener
    }
    
    public func configure(type: OlchaButtonType) {
        settings.snp.updateConstraints { make in
            make.height.equalTo(type.height)
        }
    }
}
