//
//  DescriptionSegmentsRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/07/22.
//

import UIKit
import OlchaUI
import Combine
class DescriptionSegmentsRoom: BaseTableCell {
    
    private let segmentView: ScrollableSegmentedControl = {
        let view = ScrollableSegmentedControl()
        view.segmentColor = .olchaAccentColor
        view.segmentOffset = 0.8
        return view
    }()
    
    private let segmentButtonsContainer = UIStackView()
    private let descriptionButton = IButton()
    private let characteristicsButton = IButton()
    
    weak var mainTableReloader: PassthroughSubject<ProductPage.Sections, Never>?
    
    weak var segmentObserver: PassthroughSubject<ProductPage.SegmentItem, Never>?
    
    override func setupViews() {
        container.addSubview(segmentView)
//        container.addSubview(segmentButtonsContainer)
//        segmentButtonsContainer.addArrangedSubview(descriptionButton)
//        segmentButtonsContainer.addArrangedSubview(characteristicsButton)
    }
    
    override func autolayout() {
//        segmentButtonsContainer.snp.remakeConstraints { make in
//            make.left.right.equalToSuperview().inset(16)
//            make.top.bottom.equalToSuperview()
//            make.height.equalTo(40)
//        }
//
//        descriptionButton.snp.remakeConstraints { make in
//            make.left.top.bottom.equalToSuperview().inset(2)
//        }
//
//        characteristicsButton.snp.remakeConstraints { make in
//            make.right.top.bottom.equalToSuperview().inset(2)
//        }
        segmentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    override func configureViews() {
        
        segmentButtonsContainer.round(8)
        segmentButtonsContainer.backgroundColor = .lightGrayBackground
        segmentButtonsContainer.axis = .horizontal
        segmentButtonsContainer.distribution = .fillEqually
        
        descriptionButton.setTitle("description".localized(), for: .normal)
        characteristicsButton.setTitle("characteristics".localized(), for: .normal)
        
        unselectedButtonDesign(descriptionButton)
        unselectedButtonDesign(characteristicsButton)
        
        
        descriptionButton.clicked { [weak self] in
            guard let self = self else { return }
            self.selectDescription()
            self.segmentObserver?.send(.description)
        }
        
        characteristicsButton.clicked { [weak self] in
            guard let self = self else { return }
            self.selectCharacteristic()
            self.segmentObserver?.send(.characteristics)
        }
        
        segmentView.segmentSelected = { [weak self] index in
            guard let self else { return }
            switch index {
            case 0:
//                self.selectDescription()
                self.segmentObserver?.send(.description)
            default:
//                self.selectCharacteristic()
                self.segmentObserver?.send(.characteristics)
            }
        }
    }
    
    func selectDescription() {
        unselectedButtonDesign(characteristicsButton)
        selectedButtonDesign(descriptionButton)
    }
    
    func selectCharacteristic() {
        unselectedButtonDesign(descriptionButton)
        selectedButtonDesign(characteristicsButton)
    }
    
    private func unselectedButtonDesign(_ button: UIButton) {
        button.backgroundColor = .clear
        button.round(6)
        button.titleLabel?.style(.medium, 16)
        button.setTitleColor(.olchaTextBlack, for: .normal)
    }
    
    private func selectedButtonDesign(_ button: UIButton) {
        button.backgroundColor = .olchaAccentColor
        button.round(6)
        button.titleLabel?.style(.semibold, 16)
        button.setTitleColor(.olchaWhite, for: .normal)
    }
    
    func selected(type: ProductPage.SegmentItem) {
        type == .characteristics ? selectCharacteristic() : selectDescription()
    }
}
class DescriptionSegmentsRoomView: BaseTableCellView {
    
    private let segmentView: ScrollableSegmentedControl = {
        let view = ScrollableSegmentedControl()
        view.segmentColor = .olchaAccentColor
        view.segmentOffset = 0.8
        return view
    }()
    
    private let segmentButtonsContainer = UIStackView()
    private let descriptionButton = IButton()
    private let characteristicsButton = IButton()
    
    weak var mainTableReloader: PassthroughSubject<ProductPage.Sections, Never>?
    
    weak var segmentObserver: PassthroughSubject<ProductPage.SegmentItem, Never>?
    
    override func setupViews() {
        container.addSubview(segmentView)
//        container.addSubview(segmentButtonsContainer)
//        segmentButtonsContainer.addArrangedSubview(descriptionButton)
//        segmentButtonsContainer.addArrangedSubview(characteristicsButton)
    }
    
    override func autolayout() {
//        segmentButtonsContainer.snp.remakeConstraints { make in
//            make.left.right.equalToSuperview().inset(16)
//            make.top.bottom.equalToSuperview()
//            make.height.equalTo(40)
//        }
//
//        descriptionButton.snp.remakeConstraints { make in
//            make.left.top.bottom.equalToSuperview().inset(2)
//        }
//
//        characteristicsButton.snp.remakeConstraints { make in
//            make.right.top.bottom.equalToSuperview().inset(2)
//        }
        segmentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    override func configureViews() {
        
        segmentButtonsContainer.round(8)
        segmentButtonsContainer.backgroundColor = .lightGrayBackground
        segmentButtonsContainer.axis = .horizontal
        segmentButtonsContainer.distribution = .fillEqually
        
        descriptionButton.setTitle("description".localized(), for: .normal)
        characteristicsButton.setTitle("characteristics".localized(), for: .normal)
        
        segmentView.setupSegment(titles: [
            "description".localized(),
            "characteristics".localized()
        ])
        
        descriptionButton.setTitle("description".localized(), for: .normal)
        characteristicsButton.setTitle("characteristics".localized(), for: .normal)
        
        unselectedButtonDesign(descriptionButton)
        unselectedButtonDesign(characteristicsButton)
        
        
        descriptionButton.clicked { [weak self] in
            guard let self = self else { return }
            self.selectDescription()
            self.segmentObserver?.send(.description)
        }
        
        characteristicsButton.clicked { [weak self] in
            guard let self = self else { return }
            self.selectCharacteristic()
            self.segmentObserver?.send(.characteristics)
        }
        
        segmentView.segmentSelected = { [weak self] index in
            guard let self, let type = ProductPage.SegmentItem(rawValue: index)  else { return }
            switch type {
            case .characteristics:
//                self.selectDescription()
                self.segmentObserver?.send(.characteristics)
            case .description:
                self.segmentObserver?.send(.description)
//                self.selectCharacteristic()
                
            }
        }
    }
    
    func selectDescription() {
        unselectedButtonDesign(characteristicsButton)
        selectedButtonDesign(descriptionButton)
    }
    
    func selectCharacteristic() {
        unselectedButtonDesign(descriptionButton)
        selectedButtonDesign(characteristicsButton)
    }
    
    private func unselectedButtonDesign(_ button: UIButton) {
        button.backgroundColor = .clear
        button.round(6)
        button.titleLabel?.style(.medium, 16)
        button.setTitleColor(.olchaTextBlack, for: .normal)
    }
    
    private func selectedButtonDesign(_ button: UIButton) {
        button.backgroundColor = .olchaAccentColor
        button.round(6)
        button.titleLabel?.style(.semibold, 16)
        button.setTitleColor(.olchaWhite, for: .normal)
    }
    
    func selected(type: ProductPage.SegmentItem) {
//        type == .characteristics ? selectCharacteristic() : selectDescription()
        segmentView.selectSegment(type.rawValue)
    }
}
