//
//  AddBillingCardRoom.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 02/08/23.
//

import UIKit

public class AddBillingCardRoom: BaseTableCell {
    
    private let leftButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .circle_add
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 18)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.text = "                                          "
        return label
    }()
    
    private let rightButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .rightIcon
        return imageView
    }()
    
    public let addButton = IButton()

    public override func setupViews() {
        container.addSubview(leftButton)
        container.addSubview(titleLabel)
        container.addSubview(rightButton)
        container.addSubview(addButton)
    }
    
    public override func autolayout() {
        
        leftButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(leftButton.snp.right).inset(-12)
            make.right.equalTo(rightButton.snp.left).inset(-8)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        
        makeSkeleton(views: [
            titleLabel,
            leftButton,
            rightButton
        ])
    }
    
    public func setup(with data: String?) {
        titleLabel.text = data ?? " - "
    }
    
}
