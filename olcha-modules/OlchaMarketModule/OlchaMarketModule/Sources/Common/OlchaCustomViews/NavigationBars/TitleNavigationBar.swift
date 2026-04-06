//
//  TitleNavigationBar.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/09/22.
//
import OlchaUI
import UIKit
import SnapKit
class TitleNavigationBar: UIView {
    
    let navigationTitle = UILabel()
    let backButton = IconButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initBackNavBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initBackNavBar()
    }
    
    private func initBackNavBar() {
        addSubview(navigationTitle)
        addSubview(backButton)
        
        navigationTitle.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.left.equalTo(backButton.snp.right).inset(-8)
        }
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationTitle.textAlignment = .center
        navigationTitle.style(.medium, 16)
        navigationTitle.textColor = .olchaTextBlack
        backButton.isHidden = true
        backButton.setIcon(.left_anchor)
    }
    
    func setTitle(_ title: String?) {
        navigationTitle.text = title
    }
    
}
