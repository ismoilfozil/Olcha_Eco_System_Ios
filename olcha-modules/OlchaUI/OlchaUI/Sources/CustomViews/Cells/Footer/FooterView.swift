//
//  FooterView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 14/12/22.
//


import UIKit
public class FooterView: UIView {
    public let container = UIView()
    private let separator = UIView()
    public let indicator = UIActivityIndicatorView()
    
    public enum FooterStyle {
        case white
        case gray
        case lightGray
        
        var color: UIColor? {
            switch self {
            case .white:
                return .olchaBackgroundColor
            case .gray:
                return .olchaLightNeutralGray
            case .lightGray:
                return .olchaLightNeutralGray
            }
        }
    }
    
    public var withSeparator: Bool = true {
        didSet {
            self.separator.isHidden = !withSeparator
        }
    }

    public var withEdge: Bool = true {
        didSet {
            updateLayout()
        }
    }
    
    public var height: CGFloat = 0 {
        didSet {
            updateLayout()
        }
    }
    
    public var style: FooterStyle = .white {
        didSet {
            backgroundColor = style.color
        }
    }
    
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
        addSubview(separator)
        container.addSubview(indicator)
    }
    
    private func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        indicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func configureViews() {
        separator.backgroundColor = .olchaLightNeutralGray
        separator.round(0.5)
        separator.isHidden = !withSeparator
        
        indicator.color = .olchaAccentColor
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        indicator.style = .medium
        
    }
    
    
    func updateLayout() {
        if withSeparator {
            separator.snp.updateConstraints { make in
                make.left.right.equalToSuperview().inset(withEdge ? 16 : 0)
            }
        }
        
        if height > 0 {
            container.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalTo(height)
            }
        }
    }
    
    public func topRound(_ corner: CGFloat = 12) {
        container.round(corner, topCorner: true, bottomCorner: false)
    }
    
    public func bottomRound(_ corner: CGFloat = 12) {
        container.round(corner, topCorner: true, bottomCorner: false)
    }
    
    public func configureIndicator() {
        indicator.startAnimating()
        withSeparator = false
        height = 44
    }
}
