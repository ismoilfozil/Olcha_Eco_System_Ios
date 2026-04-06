//
//  UIViewController+Snackbar.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 27/06/24.
//

import UIKit

extension UIViewController {
    
    public func showInvalidSnackbar(_ container: UIView) {
        let animatingView = createSnackbar(container: container)
        animate(snackbarView: animatingView)
    }
    
    private func createSnackbar(container: UIView) -> UIView {
        
        let snackbarView = UIView()
        snackbarView.round(14)
        snackbarView.backgroundColor = .olchaWhite.withAlphaComponent(0.88)
        
        let infoIcon = IconButton()
        infoIcon.setIcon(.info_red, edgeSize: 8, isIgnoringEdge: false)
        infoIcon.round(18)
        
        let titleLabel = UILabel()
        titleLabel.style(.medium, 16)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.numberOfLines = 0
        titleLabel.text = "invalid_service".localized()
        
        
        container.addSubview(snackbarView)
        snackbarView.addSubview(infoIcon)
        snackbarView.addSubview(titleLabel)
        
        snackbarView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        infoIcon.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(14)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(infoIcon.snp.right).inset(-16)
        }
        
        return snackbarView
    }
    
    private func animate(snackbarView: UIView) {
        snackbarView.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            snackbarView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 2) {
                snackbarView.alpha = 0
            } completion: { _ in
                snackbarView.removeFromSuperview()
            }
        }
    }
}
