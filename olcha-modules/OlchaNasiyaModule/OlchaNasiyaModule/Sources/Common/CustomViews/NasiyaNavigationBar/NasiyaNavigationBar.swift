//
//  NasiyaNavigationBar.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import UIKit
import OlchaUI
public class NasiyaNavigationBar: BaseView {
    
    public let container: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaWhite
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
        button.setIcon(.hamburger, edgeSize: 8, isIgnoringEdge: false)
        return button
    }()
    
    public let rightButton: IconButton = {
        let button = IconButton()
        button.setIcon(.bellIcon, edgeSize: 8, isIgnoringEdge: false)
        return button
    }()
    
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(centerTitle)
        container.addSubview(rightButton)
        container.addSubview(leftButton)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        centerTitle.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        rightButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
    
    public func setTitle(_ title: String?) {
        centerTitle.text = title
    }
    
}
