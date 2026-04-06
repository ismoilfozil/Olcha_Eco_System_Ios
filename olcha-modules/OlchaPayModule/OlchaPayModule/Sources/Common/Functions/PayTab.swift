//
//  PayTab.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 06/10/23.
//

import Foundation
public class PayTab {
    private static let extra_tabs = PayAppConfigurator
        .shared.isModule ? 1 : 0
    
    public static let home = extra_tabs + 0
    public static let cards = extra_tabs + 1
    public static let categories = extra_tabs + 2
    public static let monitoring = extra_tabs + 3
    
    public static func back(_ index: Int?) -> Bool {
        PayAppConfigurator.shared.isModule && (index == 0)
    }
    
}
