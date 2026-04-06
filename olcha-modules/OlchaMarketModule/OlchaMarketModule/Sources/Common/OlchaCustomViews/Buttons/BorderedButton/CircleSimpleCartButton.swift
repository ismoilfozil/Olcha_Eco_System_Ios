//
//  CircleBorderedButton.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 04/11/23.
//

import UIKit
import OlchaUI

public class CircleSimpleCartButton: BorderedButton {
    
    public let cartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .simple_cart_plus
        return imageView
    }()
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(cartImageView)
        container.addSubview(settings)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(34)
        }
        
        cartImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerX.centerY.equalToSuperview()
        }
        
        settings.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {super.configureViews()
        container.round(17)
        container.border()
    }
    
}
