//
//  OlchaIndicator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/07/22.
//

import UIKit
import SnapKit
public class OlchaIndicator: UIView {
    
    private let container = UIView()
    public let settings = UIActivityIndicatorView()
    
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
        self.container.addSubview(settings)
        self.container.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.settings.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    private func configureViews() {
        self.container.round(6)
        self.settings.color = .olchaAccentColor
        self.settings.startAnimating()
        self.settings.hidesWhenStopped = true
    }
    
    public func startAnimating() {
        settings.startAnimating()
    }
    
    public func stopAnimating() {
        settings.stopAnimating()
    }
}
