//
//  InvestNavigationBar.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 17/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class InvestNavigationBar: BaseView {
    
    public var isProfile: Bool = false {
        didSet {
            let icon: UIImage? = isProfile ? .settings : .bell
            rightButton.setIcon(icon, edgeSize: 10, isIgnoringEdge: false)
        }
    }
    
    public let container: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaWhite
        return view
    }()
    
    public let menuButton: IconButton = {
        let button = IconButton()
        button.setIcon(.bars, edgeSize: 10, isIgnoringEdge: false)
        button.icon.contentMode = .scaleAspectFit
        return button
    }()
    
    public let centerTitle: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        label.textAlignment = .center
        return label
    }()
    
    public let rightButton: IconButton = {
        let button = IconButton()
        button.setIcon(.bell, edgeSize: 10, isIgnoringEdge: false)
        button.icon.contentMode = .scaleAspectFit
        return button
    }()
    
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(menuButton)
        container.addSubview(centerTitle)
        container.addSubview(rightButton)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(-10)
        }
        menuButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        centerTitle.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.left.equalTo(menuButton.snp.right).offset(10)
            make.right.equalTo(rightButton.snp.left).offset(-10)
        }
        
        rightButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
    
    public func setTitle(_ title: String?) {
        centerTitle.text = title?.localized()
    }
    
    public func menuClicked(completion: (() -> Void)?) {
        menuButton.clicked { completion?() }
    }
    
    public func rightButtonClicked(completion: (() -> Void)?) {
        rightButton.clicked { completion?() }
    }
    
}
