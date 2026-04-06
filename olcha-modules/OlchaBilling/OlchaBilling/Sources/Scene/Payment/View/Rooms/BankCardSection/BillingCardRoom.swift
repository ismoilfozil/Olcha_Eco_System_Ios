//
//  BillingCardRoom.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 20/06/23.
//

import UIKit
import OlchaUI

public class BillingCardRoom: BaseTableCell {
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.round(6)
        imageView.backgroundColor = .lightGrayBackground1
        return imageView
    }()
    
    private let radioIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .radio_unselected
        return imageView
    }()
    
    private let cardTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let cardNumberLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let separator = Divide()

    public let button = IButton()

    public var isChosen: Bool = false {
        didSet {
            radioIcon.image = isChosen ? .radio_selected_red : .radio_unselected
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        icon.image = nil
        cardTitleLabel.text = " "
        cardNumberLabel.text = " "
    }
    
    public override func setupViews() {
        container.addSubview(icon)
        container.addSubview(radioIcon)
        container.addSubview(cardTitleLabel)
        container.addSubview(cardNumberLabel)
        container.addSubview(separator)
        container.addSubview(button)
    }
    
    public override func autolayout() {
        
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
        }
        
        radioIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        
        cardTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
//            make.bottom.equalTo(cardNumberLabel.snp.top).inset(-2)
            make.right.equalTo(radioIcon.snp.left).inset(-12)
            make.left.equalTo(icon.snp.right).inset(-12)
        }
        
        cardNumberLabel.snp.makeConstraints { make in
            make.bottom.equalTo(separator.snp.top).inset(-8)
            make.right.equalTo(radioIcon.snp.left).inset(-12)
            make.left.equalTo(icon.snp.right).inset(-12)
        }
        
        separator.snp.makeConstraints { make in
            make.left.equalTo(cardTitleLabel.snp.left)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        makeSkeleton(views: [
            
            container,
            icon,
            radioIcon,
            cardTitleLabel,
            cardNumberLabel
        
        ])
    }
    
    func setup(imageUrl: String?, name: String?, number: String?) {
        cardTitleLabel.text = name ?? " - "
        cardNumberLabel.text = number ?? " - "
        icon.load(from: imageUrl)
    }
}
