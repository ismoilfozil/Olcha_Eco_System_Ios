//
//  LeftIconButton.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/08/22.
//


import UIKit
class LeftIconButton: UIView {
    
    private let container = UIStackView()
    private let icon = UIImageView()
    let titleLabel = UILabel()
    let settings = Button()
    
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
        titleLabel.style(.medium, 16)
        titleLabel.textColor = .olchaTextBlack
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    func setIcon(_ image: UIImage?, iconSize: CGFloat = 24.0) {
        icon.image = image
        
        icon.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(iconSize)
        }
    }
    
    func enableContainer() {
        container.snp.remakeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
