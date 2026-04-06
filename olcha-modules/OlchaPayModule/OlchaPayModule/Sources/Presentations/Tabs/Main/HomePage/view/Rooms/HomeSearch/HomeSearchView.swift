//
//  HomeSearchView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 02/02/23.
//

import UIKit
import OlchaUI
public class HomeSearchView: BaseView {
    
    private lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaWhite.withAlphaComponent(0.1)
        view.round()
        return view
    }()
    
    public lazy var textField: UITextField = {
        let field = UITextField()
        
        return field
    }()
    
    public let button = IButton()
    
    public lazy var searchIcon: IconButton = {
        let button = IconButton()
        button.setIcon(.search?.withColor(.olchaWhite), isIgnoringEdge: true)
        return button
    }()
    
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(searchIcon)
        container.addSubview(textField)
        container.addSubview(button)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(40)
            make.left.equalTo(searchIcon.snp.right).inset(-8)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalTo(textField.snp.edges)
        }
    }
    
    public override func configureViews() {
        backgroundColor = .clear
        setupPlaceholder()
    }
    
    public func setupPlaceholder() {
        textField.attributedPlaceholder = .init(
            string: "search".localized() + "...",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
    }
}
