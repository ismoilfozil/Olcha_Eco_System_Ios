//
//  TooltipManager.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 05/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUtils

public protocol TooltipDelegate: NSObject {
    func tooltipDidComplete()
}

@MainActor
public class TooltipManager: NSObject {
    
    private var parentView: UIView?
    private var tooltips: [any Tooltip] = [] {
        didSet {
            tooltipsCount = tooltips.count
        }
    }
    private var tooltipsToShow: [any Tooltip] = [] {
        didSet {
            tooltipsToShowCount = tooltipsToShow.count
        }
    }
    public private(set) var tooltipsToShowCount: Int = 0
    public private(set) var tooltipsCount: Int = 0
    public var didSetupTooltips: Bool = false
    public var didViewAppear: Bool = false {
        didSet {
            guard didViewAppear else { return }
            showNext()
        }
    }
    
    private weak var scrollView: UIScrollView?
    weak var delegate: TooltipDelegate?
    
    public var verticalEdge: CGFloat = 0
    public var horizontalEdge: CGFloat = 0
    
    public func setup(tooltips: [any Tooltip], darkView: UIView, scrollView: UIScrollView? = nil) {
        guard didViewAppear else { return }
        didSetupTooltips = true
        
        self.tooltips = tooltips
        self.tooltipsToShow = tooltips
        self.parentView = darkView
        
        guard !tooltipsToShow.allSatisfy({ $0.didShow }) else {
            delegate?.tooltipDidComplete()
            return
        }
        
        self.scrollView = scrollView
        
        parentView?.addDarkView { [weak self] in
            self?.showNext()
        }
    }
    
    public func destroy() {
        didSetupTooltips = false
        didViewAppear = false
        parentView?.removeTooltipView()
        parentView?.removeSnapshots(withAnimation: false)
        parentView?.removeDarkView(withAnimation: false)
        tooltips.removeAll()
        tooltipsToShow.removeAll()
    }
    
    
    private func showNext() {
        parentView?.removeTooltipView()
        
        guard let tooltip = tooltipsToShow.first else {
            parentView?.removeDarkView()
            if tooltipsToShow.isEmpty {
                delegate?.tooltipDidComplete()
            }
            return
        }
        
        tooltipsToShow.removeFirst()
        
        guard !tooltip.didShow else {
            showNext()
            return
        }
        
        let isLast = tooltipsToShow.count == 0
        let action = isLast ? "tooltip_done_button".localized() : "tooltip_next_button".localized()
        let currentNumber = tooltipsCount - tooltipsToShowCount
        let current = tooltipsCount >= tooltipsToShowCount ? currentNumber : 0
        
        if let scrollView = scrollView {
            scrollView.scrollToView(view: tooltip.view, animated: true)
        }
        
        tooltip.view.showTooltip(
            title: tooltip.title,
            message: tooltip.message,
            action: action,
            direction: tooltip.direction,
            inView: parentView,
            current: current,
            total: tooltipsCount,
            horizontalEdge: horizontalEdge,
            verticalEdge: verticalEdge,
            onShow: { [weak self] in
                guard let self else { return }
                tooltip.addSnapshot(to: parentView, horizontalEdge: horizontalEdge, verticalEdge: verticalEdge)
            },
            onClose: { [weak self] in
                self?.tooltips.forEach({ $0.setShown() })
                self?.tooltipsToShow.removeAll()
                self?.parentView?.removeSnapshots()
                self?.showNext()
            }
        ) { [weak self] in
            tooltip.setShown()
            self?.parentView?.removeSnapshots()
            self?.showNext()
        }
    }
    
}

