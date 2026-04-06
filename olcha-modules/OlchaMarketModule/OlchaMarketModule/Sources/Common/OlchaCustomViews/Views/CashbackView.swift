//
//  CashbackView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 21/11/22.
//

import Foundation
import UIKit
class CashbackView: UIView {
    private let container = UIView()
    private let cashbackIcon = UIImageView()
    private let cashbackTitle = UILabel()
    
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
        
        addSubview(container)
        container.addSubview(cashbackIcon)
        container.addSubview(cashbackTitle)
        
        
    }
    
    private func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        cashbackIcon.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        cashbackTitle.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(cashbackIcon.snp.right).inset(-4)
        }
    }
    
    private func configureViews() {
        cashbackIcon.image = .cashback
        cashbackTitle.style(.regular, 10)
        cashbackTitle.textColor = .olchaOrange
        
        round(6)
        backgroundColor = .olchaOrange?.withAlphaComponent(0.08)
    }
    
    func setup(percent: Int?, hide: Bool = true) {
        let cashback = percent ?? 0
        if (cashback) > 0 {
            cashbackTitle.text = .lang("Кэшбэк \(cashback)%",
                                       "Кэшбэк \(cashback)%",
                                       "Keshbek \(cashback)%")
            isHidden = false
        } else {
            if hide {
                isHidden = true
            }
        }
    }
}
