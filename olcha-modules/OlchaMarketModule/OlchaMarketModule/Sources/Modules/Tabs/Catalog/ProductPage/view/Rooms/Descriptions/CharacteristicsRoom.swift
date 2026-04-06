//
//  DescriptionsRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/07/22.
//

import UIKit
import Combine
import OlchaUI
class CharacteristicsRoom: BaseTableCell {

    private let characteristicsView = CharacteristicsContainer()
    private let showAllButton = Button()
    
    private var characteristics: [CharacteristicFeature] = []
    private var isReloaded = false
    
    weak var mainTableReloader: PassthroughSubject<ProductPage.Sections, Never>?
    weak var scrollToDescription: PassthroughSubject<Bool, Never>?
    
    override func setupViews() {
        container.addSubview(characteristicsView)
        container.addSubview(showAllButton)
    }
    
    override func autolayout() {
        characteristicsView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            
        }
        
        showAllButton.snp.remakeConstraints { make in
            make.top.equalTo(characteristicsView.snp.bottom)
            make.height.equalTo(34)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    
    override func configureViews() {
        
        showAllButton.clicked { [weak self] in
            guard let self = self else { return }
            
        }
    }
    
    
    private func updateLayout() {
        let lotsCharacteristics = self.characteristics.count > 1
        showAllButton.snp.remakeConstraints { make in
            make.top.equalTo(characteristicsView.snp.bottom).inset(lotsCharacteristics ? -12 : 0)
            make.height.equalTo(lotsCharacteristics ? 34 : 0)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        showAllButton.isHidden = !lotsCharacteristics
    }
    
    
    
    func setup(with data: CharacteristicsData?) {
        if let dictionary = data?.features?.values {
            characteristics = Array(dictionary)
            characteristicsView.setup(with: characteristics)
        }
        updateLayout()
    }
}
class CharacteristicsRoomView: BaseTableCellView {
    private let characteristicsView = CharacteristicsContainer()
    let showAllButton: IButton = {
        let button = IButton()
        button.titleLabel?.style(.medium, 14)
        button.setTitleColor(.olchaAccentColor, for: .normal)
        button.backgroundColor = .olchaAccentColor.withAlphaComponent(0.1)
        button.setTitle("more".localized(), for: .normal)
        button.round(8)
        return button
    }()
    
    private var characteristics: [CharacteristicFeature] = []
    private var isReloaded = false
    
    weak var mainTableReloader: PassthroughSubject<ProductPage.Sections, Never>?
    weak var scrollToDescription: PassthroughSubject<Bool, Never>?
    
    override func setupViews() {
        container.addSubview(characteristicsView)
        container.addSubview(showAllButton)
    }
    
    override func autolayout() {
        characteristicsView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            
        }
        
        showAllButton.snp.remakeConstraints { make in
            make.top.equalTo(characteristicsView.snp.bottom)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(34)
            make.bottom.equalToSuperview()
        }
    }
    
    
    override func configureViews() {
        
    }
    
    
    private func updateLayout() {
        let lotsCharacteristics = self.characteristics.count > 1
        showAllButton.snp.remakeConstraints { make in
            make.top.equalTo(characteristicsView.snp.bottom).inset(lotsCharacteristics ? -12 : 0)
            make.height.equalTo(lotsCharacteristics ? 34 : 0)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        showAllButton.isHidden = !lotsCharacteristics
    }
    
    
    
    func setup(with data: CharacteristicsData?) {
        if let dictionary = data?.features?.values {
            characteristics = Array(dictionary)
            characteristicsView.setup(with: characteristics)
        }
        updateLayout()
    }
}
