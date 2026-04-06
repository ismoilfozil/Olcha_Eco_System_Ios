//
//  BaseViewController+Views.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/11/22.
//

import UIKit
extension BaseViewController {
    func setupConnectionViews() {
        view.addSubview(connectionContainer)
        connectionContainer.addSubview(connectionBackground)
        connectionContainer.addSubview(connectionExpandButton)
        connectionContainer.addSubview(telegramButton)
        connectionContainer.addSubview(instagramButton)
        
        autolayoutConnectionViews()
        configureConnectionViews()
    }
    
    func autolayoutConnectionViews() {
        connectionContainer.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(108)
            make.height.equalTo(112)
            make.right.equalToSuperview().inset(-rightMargin)
        }
        
        connectionBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        connectionExpandButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.left.equalToSuperview().inset(3)
            make.centerY.equalToSuperview()
        }
        
        telegramButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        instagramButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.bottom.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureConnectionViews() {
        connectionContainer.isUserInteractionEnabled = true
        connectionBackground.image = .connectionBackground
        connectionExpandButton.setIcon(.connectionExpandIcon, edgeSize: 5, isIgnoringEdge: false)
        telegramButton.setIcon(.connectionTelegram, edgeSize: 0, isIgnoringEdge: true)
        instagramButton.setIcon(.connectionInstagram, edgeSize: 0, isIgnoringEdge: true)
        
        connectionExpandButton.clicked { [weak self] in
            guard let self = self else { return }
            
            self.animateConnectionContainer()
        }
        
        telegramButton.clicked {
            Funcs.openTelegram()
        }
        
        instagramButton.clicked {
            Funcs.openInstagram()
        }
    }
    
    func animateConnectionContainer(animated: Bool = true) {
        connectionContainerIsOpened = !connectionContainerIsOpened
        
        let offset = connectionContainerIsOpened ? 22 : rightMargin
        
        connectionContainer.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(108)
            make.height.equalTo(112)
            make.right.equalToSuperview().inset(-offset)
        }
        
        UIView.animate(withDuration: animated ? 0.2 : 0) {
            self.view.layoutIfNeeded()
        }
    }
}
