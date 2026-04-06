//
//  DeeplinkCoordinator.swift
//  OlchaNasiyaModule
//
//  Created by Akhrorkhuja on 09/08/23.
//

/// 1. https://olchanasiya.uz/installment/pay/:installment_id
/// 2. https://olchanasiya.uz/installment/:installment_id
/// 3. https://olchanasiya.uz/partner/:partner_id
/// 4. https://olchanasiya.uz/limit-request/

import Foundation

public protocol DeeplinkCoordinatorProtocol {
    @discardableResult
    func handleURL(_ url: URL) -> Bool
}

public final class DeeplinkCoordinator {
    public let handlers: [DeeplinkHandlerProtocol]
    
    public init(handlers: [DeeplinkHandlerProtocol]) {
        self.handlers = handlers
    }
}

extension DeeplinkCoordinator: DeeplinkCoordinatorProtocol {
    @discardableResult
    public func handleURL(_ url: URL) -> Bool {
        guard let handler = handlers.first(where: { $0.canOpenURL(url) }) else {
            return false
        }
              
        handler.openURL(url)
        return true
    }
}
