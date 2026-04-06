//
//  GiftView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/03/23.
//

import UIKit
class GiftView: UIView {
    
    private let container = UIView()
    private let giftIcon = UIImageView()
    private let giftTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        autolayout()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(container)
        container.addSubview(giftIcon)
        container.addSubview(giftTitleLabel)
    }
    
    func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        giftIcon.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        giftTitleLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(giftIcon.snp.right).inset(-4)
        }
    }
    
    func configureViews() {
        backgroundColor = .olchaAccentColor.withAlphaComponent(0.2)
        round(6)
        
        
        giftIcon.image = .gift?.withColor(.olchaAccentColor)
        giftTitleLabel.text = "with_gift".localized()
        giftTitleLabel.style(.regular, 10)
        giftTitleLabel.textColor = .olchaAccentColor
    }
}
