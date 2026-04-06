//
//  GraphStatusView.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 17/05/23.
//

import UIKit
import OlchaUI
public class GraphStatusView: BaseView {
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public override func setupViews() {
        addSubview(titleLabel)
        addSubview(imageView)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(imageView.snp.left).inset(-8)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    public func setup(state: InstallmentGraphMonthModel.Status, title: String) {
        titleLabel.text = title
        titleLabel.textColor = state.accentColor
        imageView.image = state.icon
    }
}

