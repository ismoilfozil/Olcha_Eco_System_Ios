//
//  PriceHistoryRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/08/22.
//

import UIKit
import Combine
import OlchaUI

class PriceHistoryRoom: BaseTableCell {

    private let stackContainer = UIStackView()
    
    private let staticSection = UIView()
    let expandeButton = IconButton()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    let bottomSection = UIView()
    
    var priceChart: OlchaChart?
    
    var isExpande = false {
        didSet {
            isExpande ? shrink() : expande()
        }
    }
    
    override func setupViews() {

        container.addSubview(stackContainer)
        
        stackContainer.addArrangedSubview(staticSection)
        stackContainer.addArrangedSubview(bottomSection)
        
        staticSection.addSubview(titleLabel)
        staticSection.addSubview(expandeButton)
        staticSection.addSubview(descriptionLabel)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 16

        stackContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.right.equalTo(expandeButton.snp.left).inset(-16)
        }
        
        expandeButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.right.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(expandeButton.snp.bottom).inset(-8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    override func configureViews() {
        isExpande = false
        titleLabel.style(.semibold, 24)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.text = "price_history".localized()
        
        descriptionLabel.style(.medium, 14)
        descriptionLabel.textColor = .olchaLightTextColornnnnnn
        descriptionLabel.numberOfLines = 0
        expandeButton.setIcon(.large_shrinked)
        
        stackContainer.axis = .vertical
        stackContainer.spacing = 8
        container.round()
        container.border()
    }
    
    func setup(with data: [PriceHistory]) {
        drawPriceChart()
        priceChart?.data = data
        
        let sortedArr = data.sorted(by: { $0.price < $1.price })
        
        let priceString = (sortedArr.first?.price ?? 0).string.price + " - " + (sortedArr.last?.price ?? 0).string.price
        let diapazoneString = "diapazone".localized() + " " + priceString
        descriptionLabel.text = diapazoneString + "\n" + "tap_description".localized()
    }
    
    private func drawPriceChart() {
        if priceChart != nil {
            priceChart?.removeFromSuperview()
            priceChart = nil
        }
        priceChart = OlchaChart()
        
        if let priceChart = priceChart {
            bottomSection.addSubview(priceChart)
            
            priceChart.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalTo(120)
            }
        }
        
    }
    
    func shrink() {
        self.bottomSection.isHidden = true
    }
    
    func expande() {
        self.bottomSection.isHidden = false
    }
}
class PriceHistoryRoomView: BaseTableCellView {

    private let stackContainer = UIStackView()
    
    private let staticSection = UIView()
    let expandeButton = IconButton()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    let bottomSection = UIView()
    
    var priceChart: OlchaChart?
    
    var isExpande = false {
        didSet {
            isExpande ? shrink() : expande()
        }
    }
    
    override func setupViews() {

        container.addSubview(stackContainer)
        
        stackContainer.addArrangedSubview(staticSection)
        stackContainer.addArrangedSubview(bottomSection)
        
        staticSection.addSubview(titleLabel)
        staticSection.addSubview(expandeButton)
        staticSection.addSubview(descriptionLabel)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 16

        stackContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.right.equalTo(expandeButton.snp.left).inset(-16)
        }
        
        expandeButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.right.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(expandeButton.snp.bottom).inset(-8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    override func configureViews() {
        isExpande = false
        titleLabel.style(.semibold, 24)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.text = "price_history".localized()
        
        descriptionLabel.style(.medium, 14)
        descriptionLabel.textColor = .olchaLightTextColornnnnnn
        descriptionLabel.numberOfLines = 0
        expandeButton.setIcon(.large_shrinked)
        
        stackContainer.axis = .vertical
        stackContainer.spacing = 8
        container.round()
        container.border()
    }
    
    func setup(with data: [PriceHistory]) {
        drawPriceChart()
        priceChart?.data = data
        
        let sortedArr = data.sorted(by: { $0.price < $1.price })
        
        let priceString = (sortedArr.first?.price ?? 0).string.price + " - " + (sortedArr.last?.price ?? 0).string.price
        let diapazoneString = "diapazone".localized() + " " + priceString
        descriptionLabel.text = diapazoneString + "\n" + "tap_description".localized()
    }
    
    private func drawPriceChart() {
        if priceChart != nil {
            priceChart?.removeFromSuperview()
            priceChart = nil
        }
        priceChart = OlchaChart()
        
        if let priceChart = priceChart {
            bottomSection.addSubview(priceChart)
            
            priceChart.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalTo(120)
            }
        }
        
    }
    
    func shrink() {
        self.bottomSection.isHidden = true
    }
    
    func expande() {
        self.bottomSection.isHidden = false
    }
}
