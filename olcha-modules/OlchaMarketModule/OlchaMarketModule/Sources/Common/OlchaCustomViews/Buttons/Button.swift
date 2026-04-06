//
//  Button.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/07/22.
//

import UIKit
import SnapKit
class Button: UIButton {
    private let indicator = UIActivityIndicatorView()
    private var data: AnyObject?
    private var buttonClickListener: (() -> ())?
    var requesting = false {
        didSet {
            buttonStatusChecker()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        addTarget(self, action: #selector(clickTarget), for: .touchUpInside)
        addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.width.equalTo(indicator.frame.height)
            make.centerX.equalToSuperview()
        }
        
        indicator.color = .olchaAccentColor
        indicator.hidesWhenStopped = true
        indicator.isUserInteractionEnabled = false
        indicator.layer.zPosition = 1
    }
    
    @objc func clickTarget() {
        buttonClickListener?()
    }
    
    
    func clicked( _ data: AnyObject? = nil, _ listener: @escaping () -> Void ) {
        self.data = data
        self.buttonClickListener = listener
    }
    
    func buttonStatusChecker() {
        requesting ? indicator.startAnimating() : indicator.stopAnimating()
        isEnabled = !requesting
        backgroundColor = requesting ? backgroundColor?.withAlphaComponent(0.4) : backgroundColor?.withAlphaComponent(1)
    }
    
    
}
