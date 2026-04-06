//
//  Tooltip.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 05/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit

public protocol Tooltip: CaseIterable {
    var prefix: String { get }
    var key: String { get }
    var view: UIView { get }
    var didShow: Bool { get }
    var title: String? { get }
    var message: String { get }
    var direction: TooltipDirection { get }
    
    func setShown()
    func clearCache()
}

public extension Tooltip {
    func addSnapshot(to parentView: UIView?, horizontalEdge: CGFloat = 0, verticalEdge: CGFloat = 0) {
        guard direction != .center else { return }
        parentView?.addSnapshot(of: view, horizontalEdge: horizontalEdge, verticalEdge: verticalEdge)
    }
    
    func clearCache() {
        Self.allCases.forEach({
            UserDefaults.standard.setValue(false, forKey: $0.key)
        })
    }
    
    func setShown() {
        UserDefaults.standard.set(true, forKey: key)
    }
}
