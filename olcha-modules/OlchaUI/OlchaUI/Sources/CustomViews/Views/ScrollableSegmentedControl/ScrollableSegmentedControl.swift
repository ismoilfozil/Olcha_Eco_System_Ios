//
//  ScrollableSegmentedControl.swift
//  OlchaUI
//
//  Created by ahrorxudja on 25/09/23.
//

import UIKit
import SnapKit

public class ScrollableSegmentedControl: BaseView {
    
    public var isLoading: Bool = false
    public var segmentSelected: ((Int) -> Void)?
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 4
        return stack
    }()
    private let selectionIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    private var selectedSegmentIndex: Int = 0 {
        didSet {
//            segmentSelected?(selectedSegmentIndex)
        }
    }
    private var segmentButtons: [UIButton] = []
    private var currentTouchedButton: UIButton?
    private var segmentTitles: [String] = []
    
    public var segmentColor: UIColor? = .olchaTextBlack {
        didSet {
            selectionIndicatorView.backgroundColor = segmentColor
        }
    }
    
    public var segmentOffset: CGFloat = 1
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = CGSize(width: stackView.frame.width, height: frame.height)
    }
    
    public override func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    public override func autolayout() {
        snp.makeConstraints { make in
            make.height.equalTo(46)
        }
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualToSuperview().priority(.required)
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        
    }
    
    public func setupSegment(titles: [String]) {
        selectedSegmentIndex = 0
        segmentButtons = []
        currentTouchedButton = nil
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        segmentTitles = titles
        setupSegments()
    }
    
    private func setupSegments() {
        for (index, title) in segmentTitles.enumerated() {
            let button = IButton()
            button.tag = index
            button.addTarget(self, action: #selector(segmentTouchDown), for: .touchDown)
            button.addTarget(self, action: #selector(segmentTouchUp), for: [.touchUpInside, .touchUpOutside])
            
            let titleContainer = UIView()
            titleContainer.isUserInteractionEnabled = false
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textAlignment = .center
            titleLabel.style(.medium, 14)
            titleLabel.textColor = .olchaBlackNeutral
            titleLabel.isUserInteractionEnabled = false

            button.addSubview(titleContainer)
            titleContainer.addSubview(titleLabel)
            
            button.snp.makeConstraints { make in
                make.width.greaterThanOrEqualTo(titleContainer.snp.width)
            }
            
            titleContainer.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(8)
                make.centerY.equalTo(button.snp.centerY)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            addSubview(selectionIndicatorView)
            segmentButtons.append(button)
            stackView.addArrangedSubview(button)
            selectionIndicatorView.snp.makeConstraints { make in
                make.height.equalTo(2) // Adjust the height of the indicator
                make.bottom.equalTo(scrollView.snp.bottom)
                make.centerX.equalTo(segmentButtons[selectedSegmentIndex].snp.centerX)
                make.width.equalTo(segmentButtons[selectedSegmentIndex].snp.width) // Initial width
            }
        }
    }
    
    @objc private func segmentTouchDown(_ sender: UIButton) {
        currentTouchedButton = sender
        handleSegmentTouch(sender)
    }

    @objc private func segmentTouchUp(_ sender: UIButton) {
        currentTouchedButton = nil
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let currentButton = currentTouchedButton else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        
        if currentButton.frame.contains(touchLocation) {
            handleSegmentTouch(currentButton)
        }
    }
    
    public func setSelectedSegmentIndex(_ index: Int, animated: Bool) {
        guard index >= 0 && index < segmentButtons.count else {
            return
        }
        
        let selectedButton = segmentButtons[index]
        handleSegmentTouch(selectedButton)
    }
    
    public func selectSegment(_ index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            guard let self else { return }
            selectSegmentAutolayout(index: index)
        }
    }
    
}

private extension ScrollableSegmentedControl {
    func showBorderForSegment(_ segmentIndex: Int) {
        for (index, button) in segmentButtons.enumerated() {
            if let titleContainer = button.subviews.first {
                for borderLayer in titleContainer.layer.sublayers ?? [] {
                    borderLayer.opacity = index == segmentIndex ? 1.0 : 0.0
                }
            }
        }
    }
    
    func handleSegmentTouch(_ sender: UIButton) {
        guard !isLoading, let index = segmentButtons.firstIndex(of: sender) else {
            return
        }
        
        selectedSegmentIndex = index
        segmentSelected?(index)
        
        setNeedsLayout()
        
        UIView.animate(withDuration: 0.3) {
            self.selectSegmentAutolayout(index: index)
            self.layoutIfNeeded()
        }
    }
    
    private func selectSegmentAutolayout(index: Int) {
        guard segmentButtons.isGreater(index) else { return }
        selectionIndicatorView.snp.remakeConstraints { make in
            make.height.equalTo(2)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.centerX.equalTo(segmentButtons[index].snp.centerX)
            make.width.equalTo(segmentButtons[index].snp.width).multipliedBy(segmentOffset)
        }
    }
}
