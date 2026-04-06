//
//  CardNameView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/02/23.
//

import UIKit
import OlchaUI
public class CardNameView: BaseView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaDarkNeutralGray
        label.textAlignment = .right
        return label
    }()
    
    private let separator = Divide()
    
    public let button = IButton()
    
    public override func setupViews() {
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(separator)
        addSubview(button)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.right.equalTo(valueLabel.snp.left).inset(-16)
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints { make in
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
    
    public func setup(name: String?) {
        titleLabel.text = "card_name".localized()
        valueLabel.text = name
    }
}
