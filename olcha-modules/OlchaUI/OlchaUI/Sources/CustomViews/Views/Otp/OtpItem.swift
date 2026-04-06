//
//  OtpItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/09/22.
//

enum OtpStatus {
    case active
    case deactive(String)
    case error
    case none
}
import UIKit
class OtpItem: UIView {
    
    private let container = UIView()
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    var state: OtpStatus = .none {
        didSet {
            switch state {
            case .active:
                container.darkBorder(with: .olchaAccentColor)
                label.text = "_"
                label.textColor = .olchaAccentColor
                break
            case .deactive(let text):
                container.darkBorder()
                label.text = text
                label.textColor = .olchaTextBlack
                break
            case .none:
                container.darkBorder()
                label.text = ""
                label.textColor = .olchaTextBlack
                break
            case .error:
                container.darkBorder(with: .olchaAccentColor)
                break
            }
        }
    }
    
    
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        addSubview(container)
        container.addSubview(label)
    }
    
    private func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureViews() {
        label.textAlignment = .center
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        
        container.round(10)
        container.darkBorder()
        
    }
    
    
    
}
