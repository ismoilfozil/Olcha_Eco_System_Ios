//
//  AttachView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 27/12/22.
//

import UIKit
class AttachView: UIView {
    
    private let bannerView = UIView()
    let titleLabel = UILabel()
    private let attachPinHeight: CGFloat = 24
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        addSubview(bannerView)
        bannerView.addSubview(titleLabel)
    }
    
    private func autolayout() {
        bannerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    private func configureViews() {
        bannerView.round(6)
        bannerView.backgroundColor = .olchaWhite
        bannerView.border()
        
        titleLabel.style(.medium, 12)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.textAlignment = .center
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
    
}
