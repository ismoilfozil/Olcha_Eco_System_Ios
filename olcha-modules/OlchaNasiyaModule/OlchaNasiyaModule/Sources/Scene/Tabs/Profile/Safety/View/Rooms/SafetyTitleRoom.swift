//
//  SafetyTitleRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 23/05/23.
//

import UIKit
import OlchaUI
public class SafetyTitleRoom: BaseTableCell {

    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.style(.medium, 14)
        label.numberOfLines = 0
        label.textColor = .olchaLightTextColornnnnnn
    
        return label
    }()
    
    private let rightIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .rightIcon?.withColor(.olchaPrimaryColor)
        return imageView
    }()
    
    public override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(rightIcon)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(16)
        }
        
        rightIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).inset(-8)
        }
    }
    
    public func setup(with data: String?) {
        titleLabel.text = data ?? " - "
    }
    
}
