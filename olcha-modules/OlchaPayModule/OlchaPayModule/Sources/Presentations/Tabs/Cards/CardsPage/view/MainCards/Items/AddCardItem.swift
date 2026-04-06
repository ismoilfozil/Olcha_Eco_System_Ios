//
//  AddCardItem.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 06/02/23.
//

import UIKit
import OlchaUI
public class AddCardItem: BaseCollectionCell {
    
    private lazy var gradientContainer: GradientView = {
        let view = GradientView()
        view.round()
        view.backgroundColor = .olchaLightNeutralGray
        return view
    }()
    
    private lazy var addCardButton: LeftIconButton = {
        let button = LeftIconButton()
        button.setTitle("add_card".localized())
        button.round(8)
        button.border(with: .olchaTextBlack, width: 2)
        button.setIcon(.plus)
        button.enableContainer()
        button.settings.isEnabled = false
        return button
    }()
    
    public override func setupViews() {
        container.addSubview(gradientContainer)
        gradientContainer.addSubview(addCardButton)
    }
    
    public override func autolayout() {
        gradientContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        addCardButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(26)
            make.height.equalTo(40)
        }
        
    }
    
    public func setup() {
        addCardButton.setTitle("add_card".localized())
    }

}
