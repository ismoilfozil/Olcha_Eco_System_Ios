//
//  PayInstallmentDeeplinkHandler.swift
//  OlchaNasiyaModule
//
//  Created by Akhrorkhuja on 10/08/23.
//

import UIKit

public final class PayInstallmentDeeplinkHandler: DeeplinkHandlerProtocol {
    
    private weak var tabbarController: NasiyaMainTabbarController?
    
    public init(tabbarController: NasiyaMainTabbarController?) {
        self.tabbarController = tabbarController
    }
    
    public func canOpenURL(_ url: URL) -> Bool {
        let components = url.pathComponents
        if components.count == 4 {
            return components[1] == "installment" && components[2] == "pay" && components[3].isNumber
        }
        return false
    }
    
    public func openURL(_ url: URL) {
        let installmentId = Int(url.lastPathComponent)
        tabbarController?.selectedIndex = NasiyaTab.installments
        tabbarController?.installmentsCoordinator?.installmentsCoordinator.pushInstallment(installment: InstallmentModel(id: installmentId), shouldPay: true)
    }
}

