//
//  FilterColorItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/11/22.
//

import UIKit
import OlchaUI
class FilterColorItem: BaseCollectionCell, ChoosableCell {


    private let checkIcon = UIImageView()
    private let disableContainer = UIView()
    
    var isChosen: Bool = false {
        didSet {
            checkIcon.isHidden = !isChosen
        }
    }
    
    var enabled: Bool = false {
        didSet {
            disableContainer.isHidden = enabled
        }
    }
    
    override func setupViews() {
        container.addSubview(checkIcon)
        container.addSubview(disableContainer)
    }
    
    override func autolayout() {
        container.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.left.right.equalToSuperview().inset(4)
            
            make.width.height.equalTo(24)
        }
        
        checkIcon.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        disableContainer.snp.makeConstraints { make in
            make.edges.equalTo(container)
        }
    }
    
    override func configureViews() {
        container.round(12)
        container.border(with: .olchaLightNeutralGray)
        
        checkIcon.image = .color_check
        checkIcon.isHidden = true
        
        disableContainer.isHidden = true
        disableContainer.backgroundColor = .lightGrayBackground?.withAlphaComponent(0.65)
    }
    
    func setup(with data: String) {
        container.backgroundColor = .hex(data)
    }
}
