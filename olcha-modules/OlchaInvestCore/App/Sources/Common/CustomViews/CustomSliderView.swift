//
//  CustomSliderView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 01/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public protocol CustomSliderViewDelegate: AnyObject {
    func valueChanged(value: Int)
}

public class CustomSliderView: UIView {
    private let dotSize: CGFloat = 24
    private let slider = CustomSlider()
    private let steps = UIStackView()
    public weak var delegate : CustomSliderViewDelegate?
    
    private var min = 3 {
        didSet {
            slider.minimumValue = min.float
        }
    }
    
    private var max = 12 {
        didSet {
            slider.maximumValue = max.float
        }
    }
    
    public var forcedStep: Int = 3 {
        didSet {
            currenctStep = forcedStep
            slider.value = forcedStep.float
            slider.sendActions(for: .valueChanged)
        }
    }
    
    public var currenctStep: Int = 0
    public var step: Float = 10
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    public func setup(min: Int, max: Int, delegate: CustomSliderViewDelegate) {
        self.min = min
        self.max = max
        self.delegate = delegate
        steps.arrangedSubviews.forEach { $0.removeFromSuperview() }
        drawSteps(stack: steps)
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    
    private func setupViews() {
        addSubview(slider)
        slider.addSubview(steps)
    }
    
    private func autolayout() {
        slider.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        steps.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func configureViews() {
        backgroundColor = .clear
        
        slider.setMaximumTrackImage(.uncolor_track?.scaleTo(CGSize(width: self.frame.width, height: 12.0)), for: .normal)
        
        slider.setMinimumTrackImage(.uncolor_track?.scaleTo(CGSize(width: self.frame.width, height: 12.0)).withTintColor(.olchaAccentColor), for: .normal)
         
        slider.setThumbImage(.circle_red?.scaleTo(CGSize(width: dotSize, height: dotSize)), for: .normal)
        
        
        slider.minimumValue = min.float
        slider.maximumValue = max.float
        slider.addTarget(self,
                         action: #selector(valueChanged(_:)),
                         for: .valueChanged)
        
        steps.backgroundColor = .clear
        steps.axis = .horizontal
        steps.isUserInteractionEnabled = false
        steps.distribution = .equalCentering
        drawSteps(stack: steps)
        
    }
    
    @objc func valueChanged( _ sender: UISlider) {
        if sender.isTracking {
            slider.setThumbImage(.circle_red?.scaleTo(CGSize(width: dotSize+6, height: dotSize+6)), for: .normal)
        } else {
            slider.setThumbImage(.circle_red?.scaleTo(CGSize(width: dotSize, height: dotSize)), for: .normal)
        }
        
        let newValue = (sender.value / step).rounded(.toNearestOrAwayFromZero) * step
        sender.value = newValue
        
        currenctStep = newValue.int
       
        animateSteps(value: newValue)
        self.delegate?.valueChanged(value: newValue.int)
    }
    
    public func sendValueChangedAction() {
        slider.sendActions(for: .valueChanged)
    }
    
    private func animateSteps(value: Float) {
        steps.arrangedSubviews.forEach { $0.alpha = 1 }
        let index = (value.int / step.int) - 1
        if index < steps.arrangedSubviews.count {
            steps.arrangedSubviews[index].alpha = 0
        }
    }
    
    private func drawSteps(stack: UIStackView) {
        for _ in 0...((max-min) / step.int) {
            let step = UIView()
            stack.addArrangedSubview(step)
            step.backgroundColor = .olchaWhite.withAlphaComponent(0.4)
            step.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(4)
            }
        }
        stack.arrangedSubviews.first?.alpha = 0
    }
}
