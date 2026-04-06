//
//  LimitRequestDeeplinkHandler.swift
//  OlchaNasiyaModule
//
//  Created by Akhrorkhuja on 10/08/23.
//

import UIKit

public final class LimitRequestDeeplinkHandler: DeeplinkHandlerProtocol {
    
    private weak var tabbarController: NasiyaMainTabbarController?
    
    public init(tabbarController: NasiyaMainTabbarController?) {
        self.tabbarController = tabbarController
    }
    
    public func canOpenURL(_ url: URL) -> Bool {
        let components = url.pathComponents
        if components.count == 2 {
            return components[1] == "limit-request"
        }
        return false
    }
    
    public func openURL(_ url: URL) {
        tabbarController?.selectedIndex = NasiyaTab.home
        tabbarController?.nasiyaHomeCoordinator?.nasiyaHomeCoordinator.requestLimit()
    }
}


