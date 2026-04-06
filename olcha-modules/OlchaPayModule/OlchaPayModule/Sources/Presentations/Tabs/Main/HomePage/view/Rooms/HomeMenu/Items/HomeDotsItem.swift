//
//  HomeDotsItem.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 02/02/23.
//

import UIKit
import OlchaUI
import DropDown
public class HomeDotsItem: BaseCollectionCell {
    
    lazy var button: IconButton = {
        let button = IconButton()
        button.setIcon(.dots, isIgnoringEdge: true)
        
        return button
    }()
    
    public let dropDown = DropDown()
    
    public override func setupViews() {
        container.addSubview(button)
    }
    
    public override func autolayout() {
        button.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.centerX.equalToSuperview()
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        container.backgroundColor = .clear
        dropDown.configure(button,
                           ["Menu 1", "Menu 2", "Menu 3"],
                           width: 150,
                           offset: 50)
        
    }
    
    

}
