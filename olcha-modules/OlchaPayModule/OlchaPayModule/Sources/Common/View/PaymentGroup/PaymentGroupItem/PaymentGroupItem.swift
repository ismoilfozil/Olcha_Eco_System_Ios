//
//  PaymentGroupItem.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 03/02/23.
//

import UIKit
import OlchaUI
import OlchaUtils
public class PaymentGroupItem: BaseCollectionCell {
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    public var withBorder: Bool = false {
        didSet {
            container.border(with: .olchaLightNeutralDarkGray, width: withBorder ? 1 : 0)
        }
    }
    
    public override func setupViews() {
        container.addSubview(icon)
        container.addSubview(titleLabel)
    }
    
    public override func autolayout() {
        
        icon.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(12)
            make.width.height.equalTo(36)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).inset(-8)
            make.left.right.equalToSuperview().inset(12)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
        }
    }
    
    public override func configureViews() {
        container.round()
    }

    public func setup() {
        icon.image = UIImage(named: "mobile_tarif",
                             in: .init(identifier: BundleType.resources.identifier),
                             with: nil)
        titleLabel.text = "Коммунальные услуги"
    }
    
}
