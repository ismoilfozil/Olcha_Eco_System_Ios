//
//  SearchActionNavigationBar.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//


import UIKit
import OlchaUI
public class SearchActionNavigationBar: BaseView {
    
    public enum Status {
        case search
        case title
    }
    
    public let container: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaWhite
        return view
    }()
    
    public let defaultContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    public let centerTitle: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    public let leftButton: IconButton = {
        let button = IconButton()
        button.setIcon(.hamburger, isIgnoringEdge: true)
        return button
    }()
    
    public let searchButton: IconButton = {
        let button = IconButton()
        button.setIcon(.search_bordered, isIgnoringEdge: true)
        return button
    }()
    
    public let actionContainer: UIStackView = {
        let view = UIStackView()
        view.isHidden = true
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 12
        return view
    }()
    
    public let cancelButton: IButton = {
        let button = IButton()
        button.titleLabel?.style(.regular, 16)
        button.setTitleColor(.olchaPrimaryColor, for: .normal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.sizeToFit()
        return button
    }()
    
    public let searchField: SearchView = {
        let textField = SearchView()
        
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return textField
    }()
    
    public override func setupViews() {
        addSubview(container)
        
        container.addSubview(defaultContainer)
        defaultContainer.addSubview(centerTitle)
        defaultContainer.addSubview(searchButton)
        defaultContainer.addSubview(leftButton)
        
        container.addSubview(actionContainer)
        actionContainer.addArrangedSubview(searchField)
        actionContainer.addArrangedSubview(cancelButton)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        defaultContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        centerTitle.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        leftButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        
        actionContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
        
        searchField.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
    }
    
    public override func configureViews() {

        searchButton.clicked { [weak self] in
            guard let self = self else { return }
            changeStatus(.search)
        }
    }
    
    public func setTitle(_ title: String?) {
        centerTitle.text = title
    }
 
    public func changeStatus(_ status: Status) {
        actionContainer.isHidden = (status == .title)
        defaultContainer.isHidden = (status == .search)
    }
}
