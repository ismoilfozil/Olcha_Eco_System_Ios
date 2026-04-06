//
//  PartnerCategoryItem.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 19/06/23.
//

import UIKit
import OlchaUI

public class PartnerCategoryItem: BaseCollectionCell {
    private let checkedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .check_light
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    public override func setupViews() {
        container.addSubview(checkedImageView)
        container.addSubview(titleLabel)
    }
    
    public override func autolayout() {
        checkedImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.right.equalToSuperview().inset(4)
            make.left.equalTo(checkedImageView.snp.right).inset(-8)
        }
    }
    
    public override func configureViews() {
        container.round(7)
        container.backgroundColor = .lightGrayBackground
    }
    
    public func setup(title: String?) {
        titleLabel.text = title ?? " - "
    }
}
