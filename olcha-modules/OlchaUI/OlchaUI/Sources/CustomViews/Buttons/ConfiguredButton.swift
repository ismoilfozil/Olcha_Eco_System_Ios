//
//  ConfiguredButton.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 23/03/23.
//


import UIKit
public class ConfiguredButton: BaseView {
    public lazy var settings: IButton = {
        let button = IButton()
        return button
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public override func setupViews() {
        addSubview(titleLabel)
        addSubview(settings)
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        settings.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
