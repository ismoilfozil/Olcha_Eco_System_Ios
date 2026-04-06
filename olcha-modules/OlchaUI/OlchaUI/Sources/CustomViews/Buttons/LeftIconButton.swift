//
//  LeftIconButton.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/08/22.
//


import UIKit
public class LeftIconButton: UIView {
    
    public let container = UIStackView()
    public let icon = UIImageView()
    public let titleLabel = UILabel()
    public let settings = IButton()
    
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
        container.addArrangedSubview(icon)
        container.addArrangedSubview(titleLabel)
        addSubview(settings)
    }
    
    private func autolayout() {
        
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        settings.snp.makeConstraints { make in
            make.top.bottom.right.left.equalToSuperview()
        }
        
    }
    private func configureViews() {
        container.axis = .horizontal
        container.spacing = 8
        container.alignment = .center
        container.distribution = .fill
        titleLabel.style(.medium, 16)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.textAlignment = .center
    }
    
    public func setTitle(_ text: String?) {
        titleLabel.text = text ?? ""
    }
    
    public func setIcon(_ image: UIImage?, iconSize: CGFloat = 24.0) {
        icon.image = image
        
        icon.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(iconSize)
        }
    }
    
    public func enableContainer() {
        container.snp.remakeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
