//
//  HomeMenuItem.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 02/02/23.
//

import UIKit
import OlchaUI
public class HomeMenuItem: BaseCollectionCell {
    
    lazy var button = BorderedButton()
    
    public override func setupViews() {
        container.addSubview(button)
    }
    
    public override func autolayout() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        container.backgroundColor = .clear
        button.horizontalInset = 28
        button.verticalInset = 8
        button.background = .clear
        button.borderColor = .olchaWhite
        button.borderWidth = 1
        button.titleColor = .olchaWhite
    }
    
    func setup(with data: String) {
        button.setTitle(data)
    }
    
}
