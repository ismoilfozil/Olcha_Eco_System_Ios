//
//  PartnerFilterRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import UIKit
import OlchaUI
class PartnerFilterRoom: BaseTableCell {
    
    private let selectImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .check?.withColor(.olchaPrimaryColor)
        imageView.isHidden = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 16)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let separator = Divide()
    
    public var isChosen: Bool = false {
        didSet {
            selectImageView.isHidden = !isChosen
        }
    }
    
    public override func setupViews() {
        container.addSubview(selectImageView)
        container.addSubview(titleLabel)
        container.addSubview(separator)
    }
    
    public override func autolayout() {
        selectImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(selectImageView.snp.right).inset(-8)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    public func setup(with data: String?) {
        titleLabel.text = data ?? " - "
    }
}
