//
//  CardColorView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/02/23.
//

import UIKit
import OlchaUI
public class CardColorView: BaseView {
    private let dotSize: CGFloat = 21
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private lazy var dot: UIView = {
        let view = UIView()
        view.round(dotSize / 2)
        return view
    }()
    
    private let separator = Divide()
    
    public let button = IButton()
    
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
            make.width.height.equalTo(dotSize)
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
    
    public func setup(color: String?) {
        titleLabel.text = "card_color".localized()
        
        if let color = color {
            dot.backgroundColor = .hex(color)
        }
    }
}
