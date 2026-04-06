//
//  SearchView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/07/22.
//


import UIKit
import OlchaUtils
public class SearchView : UIView {
    private let container = UIView()
    private let leftIcon = UIImageView()
    public let textField = UITextField()
    
    private var placeholder = "" {
        didSet {
            self.textField.placeholder = placeholder
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseSetup()
    }
    
    private func baseSetup() {
        self.addSubview(container)
        self.container.addSubview(leftIcon)
        self.container.addSubview(textField)
        autolayout()
        configureViews()
        
    }
    
    private func autolayout() {
        container.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        leftIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(leftIcon.snp.right).inset(-8)
            make.right.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func configureViews() {
        container.round(10)
        container.backgroundColor = .olchaLightNeutralGray
        leftIcon.image = .textfield_search
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.font = .style(.regular, 16)
        textField.clearButtonMode = .always
    
    }
}

/// public methods
extension SearchView {
    public func setPlaceholder(_ placeholder: String = "search_with_products".localized()) {
        self.placeholder = placeholder
    }
    
    public func setContainerRadius(radius: CGFloat) {
        container.round(radius)
    }
    
    public func hideTexts() {
        self.leftIcon.isHidden = true
        self.textField.placeholder = ""
    }
    
    public func showTexts() {
        self.leftIcon.isHidden = false
        self.textField.placeholder = self.placeholder
    }
}
