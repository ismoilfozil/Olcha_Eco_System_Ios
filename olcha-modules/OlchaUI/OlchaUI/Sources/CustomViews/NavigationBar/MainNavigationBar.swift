//
//  MainNavigationBar.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/07/22.
//

import UIKit
public class MainNavigationBar: UIView, BaseNavigationInput {
    public weak var delegate: BaseNavigationOutput?
    let homeContainer = UIView()
    
    let mainIcon = UIImageView()
    let callButton = IconButton()
    let notificationButton = IconButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initHomeNavBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initHomeNavBar()
    }
    
    
    private func initHomeNavBar() {
        self.addSubview(homeContainer)
        
        self.clipsToBounds = true
        
        self.homeContainer.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        
        
        self.homeContainer.addSubview(callButton)
        self.homeContainer.addSubview(mainIcon)
        self.homeContainer.addSubview(notificationButton)
        
        self.callButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        self.mainIcon.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.centerX.centerY.equalToSuperview()
        }
        
        self.notificationButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        homeNavBarConfiguration()
        
    }
    
    private func homeNavBarConfiguration() {
        callButton.setIcon(.callIcon)
        mainIcon.image = .olchaIcon
        notificationButton.setIcon(.bellIcon)
        
    }
    
    
}
