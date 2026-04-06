//
//  TMultiField.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/08/22.
//

import UIKit
public class TMultiField: UIView {
    
    private let container = UIView()
    private let textViewContainer = UIView()
    public let titleLabel = UILabel()
    public let settings = PlaceholderTextView()
    
    public var withPlaceholder = true {
        didSet {
            settings.textColor = withPlaceholder ? .olchaLightTextColornnnnnn : .olchaTextBlack
        }
    }
    
    public var placeholder: String = "" {
        didSet {
            if withPlaceholder {
                settings.placeholder = placeholder
            }
        }
    }
    
    public var title: String = " " {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var text: String = "" {
        didSet {
            settings.text = text
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
        container.addSubview(textViewContainer)
        textViewContainer.addSubview(settings)
    }
    
    private func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        textViewContainer.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(104)
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
        }
        
        settings.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    private func configureViews() {
        titleLabel.style(.medium, 14)
        titleLabel.textColor = .olchaLightTextColornnnnnn
        titleLabel.text = title
        
        textViewContainer.darkBorder()
        textViewContainer.round()
        settings.font = .style(.medium, 14)
        
        settings.textColor = withPlaceholder ? .olchaLightTextColornnnnnn : .olchaTextBlack
        settings.backgroundColor = .clear
        
    }
    
    public func getText() -> String {
        settings.getText()
    }
}
