//
//  LeftIconView.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 12/05/23.
//

import UIKit

public class LeftIconView: BaseView {
    
    public lazy var container: UIView = {
        let view = UIView()
        view.round()
        return view
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.style(.medium, 12)
        return label
    }()
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(imageView)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview().inset(4)
            make.left.equalTo(imageView.snp.right).inset(-2)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
    }
}
