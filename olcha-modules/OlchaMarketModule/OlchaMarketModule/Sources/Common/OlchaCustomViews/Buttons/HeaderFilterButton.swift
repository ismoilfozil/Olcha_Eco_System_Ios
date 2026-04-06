//
//  HeaderFilterItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/07/22.
//
import OlchaUI
import UIKit
class HeaderFilterButton: UIView {
    private let container = UIStackView()
    private let titleLabel = UILabel()
    private let leftIcon = IconButton()
    
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
        self.addSubview(container)
        self.container.addArrangedSubview(leftIcon)
        self.container.addArrangedSubview(titleLabel)
    }
    
    private func autolayout() {
        self.container.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.left.right.equalToSuperview().inset(12)
            make.width.lessThanOrEqualTo(180)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        self.leftIcon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
    }
    
    private func configureViews() {
        self.container.axis = .horizontal
        self.container.spacing = 4
        self.titleLabel.style(.medium, 14)
        self.titleLabel.textColor = .olchaTextBlack
        self.leftIcon.setIcon(.cancel_x)
        self.round(16)
    }
    
    func selectedStyle() {
        self.leftIcon.isHidden = false
        self.titleLabel.textColor = .white
        self.backgroundColor = .olchaAccentColor
        self.border(with: .clear)
    }
    
    func unselectedStyle() {
        self.leftIcon.isHidden = true
        self.titleLabel.textColor = .olchaTextBlack
        self.backgroundColor = .clear
        self.border()
    }
    
    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }
    
    func clicked(_ action: @escaping () -> ()) {
        leftIcon.clicked(action: action)
    }
    
}
