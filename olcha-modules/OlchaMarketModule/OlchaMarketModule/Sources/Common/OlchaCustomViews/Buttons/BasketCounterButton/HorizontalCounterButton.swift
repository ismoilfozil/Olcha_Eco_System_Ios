//
//  HorizontalCounterButton.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 30/01/24.
//

import UIKit
import OlchaUI

public class HorizontalCounterButton: BaseView {
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .hex("#EFEFEF")
        view.round(14)
        return view
    }()
    
    private let minusButton: IconButton = {
        let button = IconButton()
        button.setIcon(.minus?.withColor(.olchaTextBlack), edgeSize: 0, isIgnoringEdge: true)
        button.backgroundColor = .olchaWhite
        return button
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        
        label.style(.semibold, 18)
        label.textAlignment = .center
        label.textColor = .olchaAccentColor
        label.text = "1"
        
        return label
    }()
    
    private let plusButton: IconButton = {
        let button = IconButton()
        button.setIcon(.plus?.withColor(.olchaTextBlack), edgeSize: 0, isIgnoringEdge: true)
        button.backgroundColor = .olchaWhite
        return button
    }()
    
    public var maxCount: Int = Int.max {
        didSet {
            checkButtonStates()
        }
    }
    
    public var minCount: Int = 1 {
        didSet {
            checkButtonStates()
        }
    }
    
    public var count: Int = 1 {
        didSet {
            countLabel.text = count.string
            checkButtonStates()
        }
    }
    
    @Published public var countClicked: CountType = .none
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(minusButton)
        container.addSubview(countLabel)
        container.addSubview(plusButton)
    }
    
    public override func autolayout() {
        let countSize: CGFloat = 28
        let edge: CGFloat = 2
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(114)
        }
        
        minusButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(edge)
            make.width.height.equalTo(countSize)
            make.top.bottom.equalToSuperview().inset(edge)
        }
        
        plusButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(edge)
            make.width.height.equalTo(countSize)
            make.top.bottom.equalToSuperview().inset(edge)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.left.equalTo(minusButton.snp.right).inset(-2)
            make.right.equalTo(plusButton.snp.left).inset(-2)
        }
        
        plusButton.round(countSize/2)
        minusButton.round(countSize/2)
        container.round((countSize+edge)/2)
    }
    
    public override func configureViews() {
        minusButton.clicked { [weak self] in
            guard let self else { return }
            let newValue = max(minCount, count-1)
            if newValue != count {
                count = max(minCount, count-1)
                countClicked = .minus
            }
        }
        
        plusButton.clicked { [weak self] in
            guard let self else { return }
            let newValue = min(maxCount, count+1)
            if newValue != count {
                count = newValue
                countClicked = .plus
            }
        }
    }
    
    private func disableMinus() {
        minusButton.setIcon(.minus?.withColor(.olchaLightTextColornnnnnn ?? .gray),
                            edgeSize: 0,
                            isIgnoringEdge: true)
        minusButton.backgroundColor = .olchaWhite.withAlphaComponent(0.6)
    }
    
    private func enableMinus() {
        minusButton.setIcon(.minus?.withColor(.olchaTextBlack),
                            edgeSize: 0,
                            isIgnoringEdge: true)
        minusButton.backgroundColor = .olchaWhite
    }
    
    private func disablePlus() {
        plusButton.setIcon(.plus?.withColor(.olchaLightTextColornnnnnn ?? .gray),
                           edgeSize: 0,
                           isIgnoringEdge: true)
        plusButton.backgroundColor = .olchaWhite.withAlphaComponent(0.6)
    }
    
    private func enablePlus() {
        plusButton.setIcon(.plus?.withColor(.olchaTextBlack),
                           edgeSize: 0,
                           isIgnoringEdge: true)
        plusButton.backgroundColor = .olchaWhite
    }

    private func checkButtonStates() {
        let minusButtonEnabled = count > minCount
        let plusButtonEnabled = count < maxCount
        
        minusButtonEnabled ? enableMinus() : disableMinus()
        plusButtonEnabled ? enablePlus() : disablePlus()
    }
    
    public func setup(count: Int?) {
        self.count = count ?? 1
    }
    
    public func setup(maxCount: Int?) {
        self.maxCount = maxCount ?? Int.max
    }
    
}
