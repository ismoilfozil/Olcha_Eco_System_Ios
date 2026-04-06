//
//  PartnerDescriptionRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 19/05/23.
//

import UIKit
import OlchaUI
public class PartnerDescriptionRoom: BaseView {
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.numberOfLines = 0
        label.textColor = .olchaTextBlack
        return label
    }()
    
    public override func setupViews() {
        addSubview(contentLabel)
    }
    
    public override func autolayout() {
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
    }
    
    public func setup(with data: String?) {
        contentLabel.text = data
    }
}
