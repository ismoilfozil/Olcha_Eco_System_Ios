//
//  PartnerDeeplinkHandler.swift
//  OlchaNasiyaModule
//
//  Created by Akhrorkhuja on 10/08/23.
//

import UIKit

public final class PartnerDeeplinkHandler: DeeplinkHandlerProtocol {
    
    private weak var tabbarController: NasiyaMainTabbarController?
    
    public init(tabbarController: NasiyaMainTabbarController?) {
        self.tabbarController = tabbarController
    }
    
    public func canOpenURL(_ url: URL) -> Bool {
        let components = url.pathComponents
        if components.count == 3 {
            return components[1] == "partner" && !components[2].isEmpty
        }
        return false
    }
    
    public func openURL(_ url: URL) {
        let partnerSlug = url.lastPathComponent
        tabbarController?.selectedIndex = NasiyaTab.partners
        tabbarController?.partnerCoordinator?.partnerCoordinator.pushPartnerInfo(partner: PartnerModel(slug: partnerSlug))
    }
}

