//
//  RamazanTimeHeaderRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 14/03/23.
//

import UIKit
import OlchaUI
import OlchaUtils
class RamazanTimeRoom: BaseTableCell {
    let stackContainer = UIView()
    private let numericTitleLabel = UILabel()
    private let centerTitleLabel = UILabel()
    private let rightTitleLabel = UILabel()
    
    var background: UIColor? {
        didSet {
            container.backgroundColor = background
        }
    }
    
    var isCurrentDay: Bool = false {
        didSet {
            [numericTitleLabel, centerTitleLabel, rightTitleLabel].forEach {
                $0.textColor = isCurrentDay ? .olchaAccentColor : .olchaTextBlack
            }
        }
    }
    
    override func setupViews() {
        container.addSubview(stackContainer)
        stackContainer.addSubview(numericTitleLabel)
        stackContainer.addSubview(centerTitleLabel)
        stackContainer.addSubview(rightTitleLabel)
    }
    
    override func autolayout() {
        stackContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.top.bottom.equalToSuperview()
        }
        
        numericTitleLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.333)
        }
        
        rightTitleLabel.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.333)
            
        }
        
        centerTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(numericTitleLabel.snp.right)
            make.right.equalTo(rightTitleLabel.snp.left)
            make.width.equalToSuperview().multipliedBy(0.333)
        }
    }
    
    override func configureViews() {
        
        [numericTitleLabel, centerTitleLabel, rightTitleLabel].forEach {
            $0.style(.medium, 16)
            $0.textColor = .olchaTextBlack
        }
        
        numericTitleLabel.textAlignment = .left
        rightTitleLabel.textAlignment = .right
        centerTitleLabel.textAlignment = .center
    }
    
    func setup(index: Int, model: PrayTimeModel) {
        numericTitleLabel.text = model.getDayMonth()
        centerTitleLabel.text = model.Bomdod
        rightTitleLabel.text = model.Shom
        
        
        
        let isCurrentDate = ((model.date ?? "") == Date().currentDate)
        
        [numericTitleLabel, centerTitleLabel, rightTitleLabel].forEach {
            
            $0.textColor = isCurrentDate ? .olchaAccentColor : .olchaTextBlack
            
        }
        
    }
    
    func setupHeader() {
        background = .olchaWhite
        numericTitleLabel.text = "№"
        centerTitleLabel.text = "ramazan_from".localized()
        rightTitleLabel.text = "ramazan_to".localized()
    }
}
