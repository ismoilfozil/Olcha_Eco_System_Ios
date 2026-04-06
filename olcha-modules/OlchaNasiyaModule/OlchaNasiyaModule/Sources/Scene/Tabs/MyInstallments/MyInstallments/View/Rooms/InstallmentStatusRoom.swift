//
//  InstallmentStatusRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 17/06/23.
//

import UIKit
import OlchaUI
public class InstallmentStatusRoom: BaseTableCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 16)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let rightIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .check?.withTintColor(.olchaAccentColor)
        imageView.isHidden = true
        return imageView
    }()
    
    public var isChosen: Bool = false {
        didSet {
            rightIcon.isHidden = !isChosen
            container.backgroundColor = isChosen ? .olchaLightNeutralGray : .olchaWhite
        }
    }
    
    public override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(rightIcon)
    }
    
    public override func autolayout() {
        horizontalEdge = 16
        titleLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(12)
            make.right.equalTo(rightIcon.snp.left).inset(-12)
        }
        
        rightIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(12)
            make.width.height.equalTo(20)
        }
    }
    
    public override func configureViews() {
        container.round()
    }
    
    public func setup(status: InstallmentStatus) {
        titleLabel.text = status.title
    }
}
