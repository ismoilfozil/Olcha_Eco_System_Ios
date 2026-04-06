//
//  SelectableRoom.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 23/02/23.
//

import UIKit
import OlchaUI

public class SelectableRoom: BaseTableCell {

    private lazy var checkIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.text = "Uzcard"
        return label
    }()
    
    public var isChosen: Bool? = false {
        didSet {
            configureViews()
        }
    }
    
    public override func setupViews() {
        container.addSubview(checkIcon)
        container.addSubview(titleLabel)
    }
    
    public override func autolayout() {
        checkIcon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(checkIcon.snp.right).inset(-8)
            make.top.bottom.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        checkIcon.image = (isChosen ?? false) ? .radio_checked : .radio_unchecked
    }
    
    public func setup(with data: String?) {
        titleLabel.text = data
    }
}
