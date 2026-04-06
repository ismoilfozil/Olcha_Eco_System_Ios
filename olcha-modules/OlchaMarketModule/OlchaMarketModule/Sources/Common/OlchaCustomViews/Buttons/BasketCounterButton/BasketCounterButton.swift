//
//  BasketCounterButton.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/07/22.
//

import UIKit
import OlchaUI
import Combine
public enum CountType {
    case plus
    case minus
    case none
}
open class BasketCounterButton: BaseView {
    
    private var bag = Set<AnyCancellable>()
    open var container = UIView()
    open var countTitle = UILabel()
    open var minusButton = IconButton()
    open var plusButton = IconButton()
    
    open var disableZero = false {
        didSet {
            checkButtonStates()
        }
    }
    
    @Published public var count = 1
    
    @Published public var countClicked: CountType = .none
    
    public var maxCount: Int = Int.max {
        didSet {
            checkButtonStates()
        }
    }
    
    override public func setupViews() {
        addSubview(container)
        container.addSubview(minusButton)
        container.addSubview(countTitle)
        container.addSubview(plusButton)
    }
    
    override public func autolayout() {
        container.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        minusButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        plusButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        countTitle.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(minusButton.snp.right).inset(-4)
            make.right.equalTo(plusButton.snp.left).inset(-4)
        }
    }
    
    override public func configureViews() {
        container.round(8)
        container.darkBorder()
        minusButton.setIcon(.minus, edgeSize: 0, isIgnoringEdge: true)
        plusButton.setIcon(.plus, edgeSize: 0, isIgnoringEdge: true)
        
        countTitle.style(.medium, 14)
        countTitle.textColor = .olchaTextBlack
        countTitle.text = 1.string
        countTitle.textAlignment = .center
        
        $count
            .map { $0.string }
            .assign(to: \.text, on: countTitle)
            .store(in: &bag)
        
        logic()
    }
    
    private func logic() {
        minusButton.clicked { [weak self] in
            guard let self = self else { return }
            self.checkMinusButtonState { isEnabled in
                if isEnabled {
                    self.count = max(0, self.count-1)
                    self.countClicked = .minus
                }
                self.checkButtonStates()
            }
        }
        
        plusButton.clicked { [weak self] in
            guard let self = self else { return }
            self.checkPlusButtonState { isEnabled in
                if isEnabled {
                    self.count += 1
                    self.countClicked = .plus
                } else {
                    self.count = self.maxCount
                    Funcs.showQuantityToast(quantity: self.maxCount)
                }
                self.checkButtonStates()
            }
        }
    }
    
    open func disableMinus() {
        minusButton.setIcon(.minus, edgeSize: 0, isIgnoringEdge: true)
    }
    
    open func enableMinus() {
        minusButton.setIcon(.minus?.withColor(.olchaAccentColor), edgeSize: 0, isIgnoringEdge: true)
    }
    
    open func disablePlus() {
        plusButton.setIcon(.plus?.withColor(.olchaLightTextColornnnnnn ?? .gray), edgeSize: 0, isIgnoringEdge: true)
    }
    
    open func enablePlus() {
        plusButton.setIcon(.plus?.withColor(.olchaAccentColor), edgeSize: 0, isIgnoringEdge: true)
    }
    
    public func checkMinusButtonState(_ completion: ((Bool) -> Void)) {
        if disableZero {
            if count == 1 {
                disableMinus()
                completion(false)
            } else {
                enableMinus()
                completion(true)
            }
        } else {
            enableMinus()
            completion(true)
        }
    }
    
    public func checkPlusButtonState(_ completion: ((Bool) -> Void)) {
        if count < maxCount {
            enablePlus()
            completion(true)
        } else {
            disablePlus()
            completion(false)
        }
    }
    
    public func checkButtonStates() {
        if disableZero {
            if count == 1 {
                disableMinus()
            } else {
                enableMinus()
            }
        } else {
            enableMinus()
        }
        
        if count == maxCount {
            disablePlus()
        } else {
            enablePlus()
        }
    }
}
