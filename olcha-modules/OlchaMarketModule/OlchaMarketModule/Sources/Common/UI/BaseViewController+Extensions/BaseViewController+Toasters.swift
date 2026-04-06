//
//  Toasters.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 17/08/22.
//

import UIKit

extension BaseViewController {

    enum ToastType {
        case compare
        case favourites
    }
    
    func createBottomToast(type: ToastType) {
        bottomToast?.removeFromSuperview()
        bottomToast = nil
        bottomToastTimer?.invalidate()
        
        setupBottomToast()
        autolayoutBottomToast()
        configureBottomToastViews()
        configure(with: type)
    }
    
        
    func setupBottomToast() {
        
        bottomToast = UIView()
        
        view.addSubview(bottomToast!)
        bottomToast?.addSubview(bottomToastLeftIconContainer)
        bottomToastLeftIconContainer.addSubview(bottomToastLeftIcon)
        bottomToast?.addSubview(bottomToastTitleLabel)
        bottomToast?.addSubview(bottomToastRightIcon)
        bottomToast?.addSubview(bottomToastButton)
    }
    
    func autolayoutBottomToast() {
        bottomToast?.frame = CGRect(x: 16.0,
                                    y: (UIScreen.main.bounds.height),
                                    width: self.view.frame.width - 32.0,
                                    height: 52)
        
        bottomToastLeftIconContainer.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(36)
        }
        
        bottomToastLeftIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        bottomToastRightIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        bottomToastTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(bottomToastLeftIcon.snp.right).inset(-12)
            make.right.equalTo(bottomToastRightIcon.snp.left).inset(-12)
        }
        
        bottomToastButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureBottomToastViews() {
        bottomToast?.addShadow(location: .bottom)
        bottomToast?.backgroundColor = .olchaWhite
        bottomToast?.round()
        bottomToast?.border(with: .olchaAccentColor)
        
        bottomToastLeftIconContainer.backgroundColor = .olchaAccentColor.withAlphaComponent(0.06)
        bottomToastLeftIconContainer.round(8)
        
        bottomToastTitleLabel.style(.medium, 14)
        bottomToastTitleLabel.textColor = .olchaTextBlack
        
        bottomToastRightIcon.setIcon(.rightIcon?.withColor(.grayBorder ?? .lightGray))
    }
    
    private func configure(with type: ToastType) {
        switch type {
        case .compare:
            bottomToastLeftIcon.setIcon(.compare?.withColor(.olchaAccentColor))
            bottomToastTitleLabel.text = "added_compare".localized()
        case .favourites:
            bottomToastLeftIcon.setIcon(.like_heart_filled)
            bottomToastTitleLabel.text = "added_favourites".localized()
        }
    }
    
    func showToast(type: ToastType, clicked: @escaping (() -> Void)) {
        createBottomToast(type: type)
        
        UIView.animate(withDuration: 0.3) {
            let height = (self.tabBarController?.tabBar.frame.height ?? 60) + 52.0
            self.bottomToast?.frame = CGRect(x: 16.0,
                                             y: (UIScreen.main.bounds.height - height - 24.0),
                                             width: self.view.frame.width - 32.0,
                                             height: 52.0)
        }
        
        
        bottomToastTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] (timer) in
            guard let self = self else { return }
            if self.bottomToast?.superview == self.view {
                self.bottomToast?.removeFromSuperview()
                self.bottomToast = nil
            }
        }
        
        bottomToastButton.clicked {
            clicked()
        }
    }
}
