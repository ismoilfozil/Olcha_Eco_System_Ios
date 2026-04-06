//
//  InvestTab.swift
//  OlchaInvestCore
//
//  Created by Elbek Khasanov on 06/10/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
public class InvestTab {
    private static let back_count = InvestAppConfigurator.shared.isModule ? 1 : 0
    
    public static let home = back_count + 0
    public static let packages = back_count + 1
    public static let profile = back_count + 2
    
    public static func back(_ index: Int?) -> Bool {
        InvestAppConfigurator.shared.isModule && (index == 0)
    }
}
