//
//  CancelCauseRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/12/22.
//

import UIKit
import OlchaUI
class CancelCauseRoom: BaseTableCell {

    private let checkImageView = UIImageView()
    
    private let titleLabel = UILabel()
    
    var isChecked: Bool = false {
        didSet {
            checkImageView.image = isChecked ? .checked : .unchecked
        }
    }
    
    override func setupViews() {
        container.addSubview(checkImageView)
        container.addSubview(titleLabel)
    }
    
    override func autolayout() {
        checkImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(checkImageView.snp.right).inset(-16)
        }
    }
    
    override func configureViews() {
        titleLabel.style(.medium, 16)
        titleLabel.textColor = .olchaTextBlack
    }
    
 
    func setup(with data: String) {
        titleLabel.text = data
    }
}
