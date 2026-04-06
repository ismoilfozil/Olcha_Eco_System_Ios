//
//  LoyaltyManager.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 06/07/24.
//

import UIKit
import OlchaUI
public class LoyaltyManager {
    
    nonisolated(unsafe) public static let shared = LoyaltyManager()
    
    public var mustShowNextLevel = false {
        didSet {
            showNextLevelObserver?()
        }
    }
    
    private var showNextLevelObserver: (() -> Void)?
    
    public func presentNextLevel() {
        guard mustShowNextLevel else { return }
        mustShowNextLevel = false
        let topViewController = UIApplication.shared.keyWindow?.rootViewController
        let nextLevelPage: NextLevelLoyaltyPage = CommonDIContainer.shared.resolve()
        
        topViewController?.presentModally(nextLevelPage, animated: true)
    }
    
    public func showNextLevel(_ observer: (() -> Void)?) {
        if mustShowNextLevel {
            observer?()
        } else {
            self.showNextLevelObserver = observer
        }
    }
}
