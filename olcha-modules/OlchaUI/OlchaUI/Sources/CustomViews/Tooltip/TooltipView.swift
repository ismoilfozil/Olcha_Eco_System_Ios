//
//  TooltipView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 05/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit

@MainActor
public class TooltipView: BaseView {
    
    public let topIndicatorView: TriangleView = {
        let view = TriangleView()
        view.backgroundColor = .clear
        return view
    }()
    
    public let bottomIndicatorView: InvertedTriangleView = {
        let view = InvertedTriangleView()
        view.backgroundColor = .clear
        return view
    }()
    
    public let leftIndicatorView: LeftTriangleView = {
        let view = LeftTriangleView()
        view.backgroundColor = .clear
        return view
    }()
    
    public let rightIndicatorView: RightTriangleView = {
        let view = RightTriangleView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.round(16)
        view.backgroundColor = .white
        return view
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private let topStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.alignment = .top
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaBlackNeutral
        label.numberOfLines = 0
        return label
    }()
    
    private let closeButton: IconButton = {
        let button = IconButton()
        button.setIcon(.multiply, edgeSize: 4, isIgnoringEdge: false)
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaBlackNeutral
        label.numberOfLines = 0
        return label
    }()
    
    private let bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()
    
    public let tooltipButton: OlchaButton = {
        let button = OlchaButton()
        button.backgroundColor = .olchaPrimaryColor
        button.settings.setTitleColor(.white, for: .normal)
        button.settings.titleLabel?.font = .style(.semibold, 14)
        button.round(6)
        return button
    }()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    public var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    public var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
    public var closeCallback: (() -> Void)?
    public var showCallBack: (() -> Void)?
    public var removeCallback: (() -> Void)?
    
    public override func setupViews() {
        addSubview(contentView)
        contentView.addSubview(contentStack)
        contentStack.addArrangedSubview(topStack)
        topStack.addArrangedSubview(titleLabel)
        topStack.addArrangedSubview(closeButton)
        contentStack.addArrangedSubview(descriptionLabel)
        contentStack.addArrangedSubview(bottomStack)
        bottomStack.addArrangedSubview(tooltipButton)
        bottomStack.addArrangedSubview(counterLabel)
        addSubview(topIndicatorView)
        addSubview(bottomIndicatorView)
        addSubview(leftIndicatorView)
        addSubview(rightIndicatorView)
    }
    
    public override func autolayout() {
        topIndicatorView.snp.makeConstraints { make in
            make.centerX.equalTo(bottomIndicatorView.snp.centerX)
            make.top.equalToSuperview()
            make.bottom.equalTo(contentView.snp.top)
            make.height.equalTo(6)
            make.width.equalTo(14)
        }
        bottomIndicatorView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom)
            make.bottom.equalToSuperview()
            make.height.equalTo(6)
            make.width.equalTo(14)
        }
        leftIndicatorView.snp.makeConstraints { make in
            make.centerY.equalTo(rightIndicatorView.snp.centerY)
            make.trailing.equalTo(contentView.snp.leading)
            make.height.equalTo(14)
            make.width.equalTo(6)
        }
        rightIndicatorView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.trailing)
            make.height.equalTo(14)
            make.width.equalTo(6)
        }
        contentView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.centerY.equalTo(leftIndicatorView.snp.centerY)
            make.leading.trailing.equalToSuperview().inset(10)
            make.width.lessThanOrEqualTo(250)
            make.width.greaterThanOrEqualTo(150)
        }
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        tooltipButton.snp.makeConstraints { make in
            make.height.equalTo(28)
        }
    }
    
    public override func configureViews() {
        isHidden = true
        closeButton.clicked { [weak self] in
            self?.closeCallback?()
        }
        tooltipButton.clicked { [weak self] in
            self?.hide()
        }
    }
    
    public func setupCounter(current: Int, total: Int) {
        bottomStack.isHidden = total <= 1
        counterLabel.text = "\(current)/\(total)"
    }
    
    public func show() {
        fadeIn { [weak self] in
            self?.showCallBack?()
        }
    }
    
    public func hide() {
        removeCallback?()
        fadeOut {
            self.removeFromSuperview()
        }
    }
    
}

@MainActor
extension UIView {
    func showTooltip(
        title: String? = nil,
        message: String,
        timeout: TimeInterval = 10,
        action: String? = nil,
        direction: TooltipDirection,
        inView: UIView? = nil,
        current: Int,
        total: Int,
        horizontalEdge: CGFloat,
        verticalEdge: CGFloat,
        onShow: (() -> Void)? = nil,
        onClose: (() -> Void)? = nil,
        onHide: (() -> Void)? = nil
    ) {
        removeTooltipView()

        guard let superview = inView ?? superview else { return }

        let tooltipView = TooltipView()
        tooltipView.titleText = title
        tooltipView.descriptionText = message
        tooltipView.closeCallback = onClose
        tooltipView.showCallBack = onShow
        tooltipView.removeCallback = onHide
        tooltipView.tooltipButton.setTitle(action.unwrap)
        tooltipView.setupCounter(current: current, total: total)
//            tooltipView.actionButton.isHidden = action == nil
        
        tooltipView.rightIndicatorView.isHidden = direction != .right
        tooltipView.leftIndicatorView.isHidden = direction != .left
        tooltipView.topIndicatorView.isHidden = direction != .up
        tooltipView.bottomIndicatorView.isHidden = direction != .down
        
        superview.addSubview(tooltipView)
        
        switch direction {
        case .up:
            tooltipView.snp.makeConstraints { make in
                make.top.equalTo(self.snp.bottom).inset(-verticalEdge)
            }
        case .down:
            tooltipView.snp.makeConstraints { make in
                make.bottom.equalTo(self.snp.top).inset(-verticalEdge)
            }
        case .right:
            tooltipView.snp.makeConstraints { make in
                make.trailing.equalTo(self.snp.leading).inset(-horizontalEdge)
            }
        case .left:
            tooltipView.snp.makeConstraints { make in
                make.leading.equalTo(self.snp.trailing).inset(-horizontalEdge)
            }
        case .center:
            NSLayoutConstraint.activate([
                tooltipView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
                tooltipView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
                tooltipView.leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor, constant: 37),
                tooltipView.trailingAnchor.constraint(greaterThanOrEqualTo: superview.trailingAnchor, constant: 37)
            ])
        }
        
        tooltipView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(superview.safeAreaLayoutGuide)
            make.bottom.lessThanOrEqualTo(superview.safeAreaLayoutGuide)
            make.leading.greaterThanOrEqualTo(superview.safeAreaLayoutGuide)
            make.trailing.lessThanOrEqualTo(superview.safeAreaLayoutGuide)
        }
//
        if direction.isVertical {
            tooltipView.snp.makeConstraints { make in
                make.centerX.equalTo(self.snp.centerX).priority(.medium)
                make.leading.greaterThanOrEqualTo(superview.snp.leading)
                make.trailing.lessThanOrEqualTo(superview.snp.trailing)
            }
            tooltipView.topIndicatorView.snp.makeConstraints { make in
                make.centerX.equalTo(self.snp.centerX)
            }
        } else if direction.isHorizontal {
            tooltipView.snp.makeConstraints { make in
                make.centerY.equalTo(self.snp.centerY).priority(.high)
                make.top.greaterThanOrEqualTo(superview.snp.top)
                make.bottom.lessThanOrEqualTo(superview.snp.bottom)
            }
            tooltipView.leftIndicatorView.snp.makeConstraints { make in
                make.centerY.equalTo(self.snp.centerY)
            }
        }
        
        tooltipView.show()
    }
    
    public func removeTooltipView() {
        for subview in self.subviews where subview is TooltipView {
            subview.removeFromSuperview()
        }
    }
}
