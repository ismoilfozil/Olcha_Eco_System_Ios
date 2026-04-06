//
//  LocationCardRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/09/22.
//

import UIKit
import OlchaUI
class LocationCardRoom: BaseTableCell {

    
    
    private let locationTitle = UILabel()
    
    private let datasStack = UIStackView()
    
    private let floorTitle = UILabel()
    
    private let entranceTitle = UILabel()
    
    private let flatTitle = UILabel()
    
    private let changeStateButtonContainer = UIView()
    
    private let madeDefaultButton = LeftIconButton()
    
    private let makeDefaultButton = UILabel()

    let editIconButton = IconButton()

    let changeStateButton = Button()
    
    let deleteButton = LeftIconButton()
    
    override func setupViews() {
        
        container.addSubview(editIconButton)
        container.addSubview(locationTitle)
        container.addSubview(datasStack)
        
        datasStack.addArrangedSubview(floorTitle)
        datasStack.addArrangedSubview(entranceTitle)
        datasStack.addArrangedSubview(flatTitle)
        
        container.addSubview(deleteButton)
        container.addSubview(changeStateButtonContainer)
        
        changeStateButtonContainer.addSubview(madeDefaultButton)
        changeStateButtonContainer.addSubview(makeDefaultButton)
        
        changeStateButtonContainer.addSubview(changeStateButton)
        
    }
    
    override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 8
        
        editIconButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.right.equalToSuperview().inset(16)
        }
        
        locationTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
            make.right.equalTo(editIconButton.snp.left).inset(-24)
        }
        
        datasStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(locationTitle.snp.bottom).inset(-8)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(datasStack.snp.bottom).inset(-16)
            make.height.equalTo(20)
        }
        
        changeStateButtonContainer.snp.makeConstraints { make in
            make.top.equalTo(deleteButton.snp.bottom).inset(-12)
            make.left.right.bottom.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        makeDefaultButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        madeDefaultButton.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        changeStateButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        container.border(width: 2)
        container.round()
        
        locationTitle.style(.bold, 16)
        locationTitle.textColor = .olchaTextBlack
        locationTitle.numberOfLines = 0
        
        editIconButton.setIcon(.pen, isIgnoringEdge: false)
        editIconButton.round(8)
        editIconButton.border()
        
        datasStack.axis = .vertical
        datasStack.spacing = 4
        
        floorTitle.style(.medium, 14)
        floorTitle.textColor = .olchaLightTextColornnnnnn
        
        entranceTitle.style(.medium, 14)
        entranceTitle.textColor = .olchaLightTextColornnnnnn
        
        flatTitle.style(.medium, 14)
        flatTitle.textColor = .olchaLightTextColornnnnnn
        
        deleteButton.setIcon(.trash_blue?.withColor(.olchaAccentColor), iconSize: 20)
        deleteButton.titleLabel.style(.medium, 14)
        deleteButton.titleLabel.textColor = .olchaAccentColor
        deleteButton.setTitle("delete".localized())
        
        
        changeStateButtonContainer.backgroundColor = .olchaAccentColor
        
        changeStateButtonContainer.round()
        
        
        makeDefaultButton.textColor = .olchaWhite
        makeDefaultButton.text = "make_default".localized()
        makeDefaultButton.style(.medium, 14)
        
        madeDefaultButton.titleLabel.textColor = .olchaWhite
        madeDefaultButton.titleLabel.text = "default".localized()
        madeDefaultButton.titleLabel.style(.medium, 14)
        madeDefaultButton.setIcon(.check, iconSize: 20)
        
        
        makeDefaultButton.isHidden = false
        madeDefaultButton.isHidden = true
    }
    
    func setup(with data: UserAddress) {
        locationTitle.text = data.getFullAddress()
        
        if let floor = data.floor {
            floorTitle.isHidden = false
            floorTitle.text = "floor".localized() + ": " + floor
        } else {
            floorTitle.isHidden = true
        }
        
        if let podyezd = data.entrance {
            entranceTitle.text = "podyezd".localized() + ": " + podyezd
            entranceTitle.isHidden = false
        } else {
            entranceTitle.isHidden = true
        }
        
        if let kvartira = data.house_number {
            flatTitle.text = "flat".localized() + ": " + kvartira
            flatTitle.isHidden = false
        } else {
            flatTitle.isHidden = true
        }
    }
    
    
    func changeState(isDefault: Bool) {
        makeDefaultButton.isHidden = isDefault
        madeDefaultButton.isHidden = !isDefault
        
        if isDefault {
            container.border(with: .olchaAccentColor, width: 2)
        } else {
            container.border(width: 2)
        }
    }
}
