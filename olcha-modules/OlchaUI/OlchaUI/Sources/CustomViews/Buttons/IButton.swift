//
//  Button.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/07/22.
//

import UIKit
import SnapKit
public class IButton: UIButton {
    private let indicatorContainer = UIView()
    private let indicator = UIActivityIndicatorView()
    private var buttonClickListener: (() -> ())?
    public var requesting = false {
        didSet {
//            if oldValue != requesting {
                buttonStatusChecker()
//            }
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        addTarget(self, action: #selector(clickTarget), for: .touchUpInside)
        addSubview(indicatorContainer)
        indicatorContainer.addSubview(indicator)
        
        indicatorContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        indicator.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        indicator.style = .medium
        indicator.color = .olchaAccentColor
        indicator.startAnimating()
        
        indicatorContainer.isHidden = true
        indicatorContainer.isUserInteractionEnabled = false
        indicatorContainer.backgroundColor = .olchaWhite.withAlphaComponent(0.4)
    }
    
    @objc public func clickTarget() {
        buttonClickListener?()
    }
    
    
    public func clicked( _ listener: @escaping () -> Void ) {
        self.buttonClickListener = listener
    }
    
    public func buttonStatusChecker() {
        indicatorContainer.isHidden = !requesting
        indicatorContainer.isUserInteractionEnabled = requesting
        requesting ? indicator.startAnimating() : indicator.stopAnimating()
    }
    
    public func seeAllConfigure() {
        self.titleLabel?.style(.medium, 16)
        self.setTitleColor(.olchaAccentColor, for: .normal)
        self.setTitle("see_all".localized(), for: .normal)
    }
}
