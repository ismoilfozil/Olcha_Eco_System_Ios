//
//  CostTitleView.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 06/02/24.
//

import UIKit
import OlchaUI
class CostTitleView: BaseView {
    
    let container = UIView()
    
    let settings: UILabel = {
        let label = UILabel()
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let actionsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    let infoButton: IconButton = {
        let button = IconButton()
        button.setIcon(.cart_info, isIgnoringEdge: true)
        button.isHidden = true
        return button
    }()
    
    let countLabel: Label = {
        let label = Label()
        label.backgroundColor = .hex("707070").withAlphaComponent(0.2)
        label.settings.style(.medium, 13)
        label.settings.textColor = .olchaTextBlack
        label.verticalInset = 2
        label.horizontalInset = 2
        label.settings.textAlignment = .center
        label.round(8)
        label.isHidden = true
        return label
    }()
    
    var infoSize: CGFloat = 16 {
        didSet {
            infoButton.snp.remakeConstraints { make in
                make.width.height.equalTo(infoSize)
            }
            infoButton.round(infoSize/2)
        }
    }
    
    var countSize: CGFloat = 16 {
        didSet {
            countLabel.snp.remakeConstraints { make in
                make.width.height.equalTo(countSize)
            }
            countLabel.round(countSize/2)
        }
    }
    
    override func setupViews() {
        addSubview(container)
        container.addSubview(settings)
        container.addSubview(actionsContainer)
        actionsContainer.addArrangedSubview(infoButton)
        actionsContainer.addArrangedSubview(countLabel)
    }
    
    override func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        settings.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        actionsContainer.snp.makeConstraints { make in
            make.right.lessThanOrEqualToSuperview()
            make.left.equalTo(settings.snp.right).inset(-4)
            make.centerY.equalTo(settings.snp.centerY)
        }
        
        infoSize = 16
        
        countSize = 16
        
    }
    
}
