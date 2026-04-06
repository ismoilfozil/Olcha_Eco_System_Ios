//
//  SideMenuItem.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/06/23.
//

import UIKit
import OlchaUI
public class SideMenuItem: BaseView {
    
    public var MENU_TAG: Int = -1
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    public let button = IButton()
    
    public override func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(button)
    }
    
    public override func autolayout() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(4)
            make.left.equalTo(imageView.snp.right).inset(-12)
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func setup(image: UIImage?, title: String?) {
        imageView.image = image
        titleLabel.text = title ?? " - "
    }
    
    public func setup(color: UIColor?) {
        titleLabel.textColor = color
    }
}
