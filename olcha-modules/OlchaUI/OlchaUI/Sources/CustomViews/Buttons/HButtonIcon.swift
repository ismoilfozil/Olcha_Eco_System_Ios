//
//  HButtonIcon.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/07/22.
//

import UIKit
import SnapKit

public class HButtonIcon: UIView {
    
    private let container = UIView()
    public let buttonTitle = UILabel()
    private let buttonIcon = UIImageView()
    private let button = UIButton()
    
    public var background: UIColor? = .olchaLightNeutralGray {
        didSet {
            self.container.backgroundColor = background
        }
    }
    
    public var index = 0
    public var buttonAction: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        autolayout()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupViews() {
        self.addSubview(container)
        self.container.addSubview(buttonTitle)
        self.container.addSubview(buttonIcon)
        self.container.addSubview(button)
    }
    
    private func autolayout() {
        self.container.snp.makeConstraints { make in
            make.bottom.left.right.top.equalToSuperview()
        }
        
        self.buttonTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(6)
        }
        
        self.buttonIcon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.right.equalToSuperview().inset(8)
            make.left.equalTo(self.buttonTitle.snp.right).inset(-4)
            make.centerY.equalToSuperview()
        }
        
        self.button.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    private func configureViews() {
        self.container.backgroundColor = background
        self.container.round(8)
        self.buttonTitle.textAlignment = .center
        self.buttonTitle.style(.medium, 14)
        self.buttonTitle.textColor = .olchaTextBlack
        
        self.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    

    public func setTitle(_ text: String?) {
        self.buttonTitle.text = text ?? ""
    }
    
    public func setIcon(_ image: UIImage?) {
        self.buttonIcon.image = image
    }
    
    public func clicked(_ action: @escaping () -> ()) {
        self.buttonAction = action
    }
    
    @objc func buttonClicked() {
        buttonAction?()
    }
}
