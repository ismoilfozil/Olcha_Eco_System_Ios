//
//  RateBoxView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 19/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class RateBoxView: BaseView {
    
    public enum RateStyle {
        case left
        case right
    }
    
    private lazy var rateGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.locations = [0.0, 0.5]
        gradient.startPoint = CGPoint(x: 0.8, y: 0.8)
        gradient.endPoint = CGPoint(x: 0.2, y: 0.2)
        return gradient
    }()
    
    private let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.text = "Text"
        label.style(.medium, 14)
        label.numberOfLines = 2
        return label
    }()
    
    private let rateAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.style(.semibold, 18)
        label.numberOfLines = 2
        return label
    }()
    
    private let rateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var gradientColor: UIColor = .olchaAccentColor
    public var style: RateStyle = .left {
        didSet {
            updateLayout()
        }
    }
    
    public override func setupViews() {
        self.addSubview(rateImageView)
        self.addSubview(labelStack)
        labelStack.addArrangedSubview(rateLabel)
        labelStack.addArrangedSubview(rateAmountLabel)
    }
    
    public override func autolayout() {
        labelStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        rateImageView.snp.makeConstraints { make in
            switch style {
            case .left:
                make.right.bottom.equalToSuperview()
            case .right:
                make.left.bottom.equalToSuperview()
            }
        }
    }
    
    public override func configureViews() {
        self.backgroundColor = .white
        self.round()
    }
    
    public func updateLayout() {
        rateAmountLabel.textAlignment = style == .right ? .right : .left
        rateImageView.snp.remakeConstraints { make in
            switch style {
            case .left:
                make.right.bottom.equalToSuperview()
            case .right:
                make.left.bottom.equalToSuperview()
            }
        }
    }
    
    public func setRateAmountLabelColor(_ textColor: UIColor?) {
        rateAmountLabel.textColor = textColor
    }
    
    public func setRateAmountLabelText(_ text: String) {
        rateAmountLabel.text = text
    }
    
    public func setRateLabelText(_ text: String) {
        rateLabel.text = text
    }
    
    public func setRateImage(image: UIImage?) {
        rateImageView.image = image
    }
    
    public func setRateBoxGradient(_ color: UIColor?) {
        guard let color = color else { return }
        gradientColor = color
        let colors: [CGColor] = [gradientColor.cgColor, gradientColor.withAlphaComponent(0.2).cgColor]
        self.removeCAGradientLayers()
        rateGradient.colors = colors
        rateGradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.insertSublayer(rateGradient, at: 0)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setRateBoxGradient(gradientColor)
    }
    
}
