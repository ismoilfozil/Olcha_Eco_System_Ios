//
//  OlchaIndicator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/07/22.
//

import UIKit
import SnapKit
class OlchaIndicator: UIView {
    
    private let container = UIView()
    private let indicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
        configureViews()
        
    }
    
    private func baseSetup() {
        self.addSubview(container)
        self.container.addSubview(indicator)
        self.container.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.indicator.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    private func configureViews() {
        self.container.round(6)
        self.indicator.color = .olchaAccentColor
        self.indicator.startAnimating()
        self.indicator.hidesWhenStopped = true
    }
}
