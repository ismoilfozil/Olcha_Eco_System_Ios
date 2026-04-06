//
//  MonitoringActionsHeader.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 22/02/23.
//


import UIKit
import OlchaUI
public class MonitoringActionsHeader: BaseView {
    
    private lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaLightNeutralGray
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        label.text = "monitoring".localized()
        return label
    }()
    
    public lazy var filtrButton: IButton = {
        let button = IButton()
        button.setTitle("filtr".localized(), for: .normal)
        button.setTitleColor(.olchaAccentColor, for: .normal)
        button.titleLabel?.style(.medium, 16)
        return button
    }()
    
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(filtrButton)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        filtrButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    public override func languageUpdated() {
        titleLabel.text = "monitoring".localized()
        filtrButton.setTitle("filtr".localized(), for: .normal)
    }
}
