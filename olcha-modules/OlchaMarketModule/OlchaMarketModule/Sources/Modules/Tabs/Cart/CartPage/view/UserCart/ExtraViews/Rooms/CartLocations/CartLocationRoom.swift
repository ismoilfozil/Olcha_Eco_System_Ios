//
//  CartLocationRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/09/22.
//

import UIKit
import OlchaUI

class CartLocationRoom: BaseTableCell {
    
    let locationView: HorizontalButton = {
        let view = HorizontalButton()
        
        view.leftIconSize = 20
        view.settings.numberOfLines = 0
        view.settings.textAlignment = .left
        view.rightIconSize = 24
        
        view.setup(leftIcon: .radio_unselected)
        view.setup(rightIcon: nil)
        
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let editButton: IconButton = {
        let button = IconButton()
        button.setIcon(.edit_settings)
        return button
    }()
    
    private let separator = Divide()
    
    var isChosen: Bool = false {
        didSet {
            locationView.setup(leftIcon: isChosen ? .round_selected_check : .round_unselected_check)
        }
    }
    
    override func setupViews() {
        container.addSubview(locationView)
        container.addSubview(editButton)
        container.addSubview(separator)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 4
        
        locationView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(14)
        }
        
        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.left.equalTo(locationView.snp.right).inset(-16)
            make.right.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        locationView.setup(leftIcon: .round_unselected_check)
        
        makeSkeleton(views: [
            container,
            locationView
        ])
    }
    
    func setup(with data: UserAddress) {
        locationView.text = data.getFullAddress()
    }
}
