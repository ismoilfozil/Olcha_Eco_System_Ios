//
//  PriceHistoryModalPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/12/22.
//

import UIKit

class PriceHistoryModalPage: BaseViewController {
    
    var priceChart: OlchaChart?
    
    var priceHistory: [PriceHistory] = [] {
        didSet {
            setup(with: priceHistory)
        }
    }
    
    private let descriptionLabel = UILabel()
    private let bottomSection = UIView()
    
    override func viewDidLoad() {
        setupModalViews()
        modalAutolayout()
        configureModalViews(header: "price_history".localized())
    }

    override func setupModalViews() {
        super.setupModalViews()
        modalContainer.addSubview(descriptionLabel)
        modalContainer.addSubview(bottomSection)
    }
    
    override func modalAutolayout() {
        super.modalAutolayout()
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
        }
        
        bottomSection.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).inset(-8)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    override func configureModalViews(header: String = "", textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: header, textAlignment: textAlignment)
        descriptionLabel.style(.medium, 14)
        descriptionLabel.textColor = .olchaLightTextColornnnnnn
        descriptionLabel.numberOfLines = 0
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
        priceChart?.removeFromSuperview()
        priceChart = nil
        priceChart = OlchaChart()
        
        if let priceChart = priceChart {
            bottomSection.addSubview(priceChart)
        }
        
        priceChart?.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(120)
        }
    }
}
