//
//  WelcomViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 27/04/23.
//

import UIKit
import ViewAnimator
import OlchaUI
class SplashPage: BaseViewController<EmptyNavigationBar> {

    private lazy var olchaImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .olcha_market
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var observer: (() -> Void)?
    
    override func setupViews() {
        container.addSubview(olchaImg)
    }
    
    override func autolayout() {
        olchaImg.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(32)
        }
    }
    
    override func configureViews() {
        olchaImg.animate(animations: [AnimationType.zoom(scale: 4)], delay: 0, duration: 1) { [weak self] in
            guard let self = self else { return }
            self.presentHome()
        }
    }

    func presentHome() {
        observer?()
    }
    
    func presentFinished(_ observer: (() -> Void)?) {
        self.observer = observer
    }
    
}
