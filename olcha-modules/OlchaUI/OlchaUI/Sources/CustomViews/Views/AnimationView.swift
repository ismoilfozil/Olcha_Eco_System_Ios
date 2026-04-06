//
//  AnimationView.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 24/06/23.
//

import UIKit
import Lottie
public class AnimationView: BaseView {
    public var settings = LottieAnimationView()
    
    public override func setupViews() {
        addSubview(settings)
    }
    
    public override func autolayout() {
        settings.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        settings.contentMode = .scaleAspectFit
        settings.loopMode = .autoReverse
    }
    
    public func setup(bundleIdentifier: String?,
                 name: String?
    ) {
        
        guard let bundleIdentifier = bundleIdentifier,
              let bundle = Bundle(identifier: bundleIdentifier),
              let name = name
        else { return }
        
        settings.animation = LottieAnimation.named(name, bundle: bundle)
        
        settings.play()
    }
    
    
}
