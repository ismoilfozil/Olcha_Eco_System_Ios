//
//  MakeDefaultView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/02/23.
//

import UIKit
import OlchaUI
public class CardMakeDefaultView: BaseView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private lazy var dot: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let separator = Divide()
    
    public let button = IButton()
    
    public var isSelected: Bool = false {
        didSet {
            dot.image = isSelected ? .switch_on : .switch_off
        }
    }
    
    public override func setupViews() {
        addSubview(titleLabel)
        addSubview(dot)
        addSubview(separator)
        addSubview(button)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.right.equalTo(dot.snp.left).inset(-16)
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview()
        }
        
        dot.snp.makeConstraints { make in
            make.width.equalTo(39)
            make.height.equalTo(21)
            make.right.equalToSuperview()
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).inset(-16)
            make.bottom.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func setup(isDefault: Bool?) {
        titleLabel.text = "make_default".localized()
        isSelected = isDefault ?? false
    }

}
