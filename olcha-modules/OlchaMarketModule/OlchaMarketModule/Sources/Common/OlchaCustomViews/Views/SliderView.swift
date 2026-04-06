//
//  SliderView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 27/07/22.
//

import UIKit
import OlchaUI
protocol SliderViewDelegate: AnyObject {
    func valueChanged(month: Int)
}
class SliderView: UIView {
    private let dotSize: CGFloat = 24
    private let slider = CustomSlide()
    private let steps = UIStackView()
    weak var delegate : SliderViewDelegate?
    
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
            slider.value = forcedStep.float
            animateSteps(value: forcedStep.float)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    func setup(min: Int, max: Int, delegate: SliderViewDelegate) {
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
    lazy var oldValue: Float = min.float
    @objc func valueChanged( _ sender: UISlider) {
        if sender.isTracking {
            slider.setThumbImage(.circle_red?.scaleTo(CGSize(width: dotSize+6, height: dotSize+6)), for: .normal)
        } else {
            slider.setThumbImage(.circle_red?.scaleTo(CGSize(width: dotSize, height: dotSize)), for: .normal)
        }
        
        
        var newValue = sender.value
        
        if newValue > oldValue {
            newValue = newValue.rounded()
        } else if newValue < oldValue {
            newValue = newValue.rounded()
        }
        
        
        oldValue = newValue
        sender.value = newValue
        
       
        animateSteps(value: newValue)
        self.delegate?.valueChanged(month: newValue.int)
    }
    
    private func animateSteps(value: Float) {
        steps.arrangedSubviews.forEach { $0.alpha = 1 }
        let index = (value.int - min)
        if index < steps.arrangedSubviews.count {
            steps.arrangedSubviews[index].alpha = 0
        }
    }
    
    private func drawSteps(stack: UIStackView) {
        for _ in 0..<max-min+1 {
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

class CustomSlide: UISlider {
    private let trackHeight: CGFloat = 4
    
    
    var thumbTouchSize : CGSize = CGSize(width: 30, height: 30)
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let bounds = self.bounds.insetBy(dx: -thumbTouchSize.width, dy: -thumbTouchSize.height)
        return bounds.contains(point)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        true
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var result = super.trackRect(forBounds: bounds)
        result.origin.x = 0
        result.size.width = bounds.size.width
        result.size.height = trackHeight
        return result
    }

    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        return super.thumbRect(forBounds:
            bounds, trackRect: rect, value: value)
            .offsetBy(dx: 0, dy: 0)
    }
    
}
