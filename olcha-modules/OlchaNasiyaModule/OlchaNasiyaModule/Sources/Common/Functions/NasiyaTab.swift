//
//  NasiyaTab.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 06/10/23.
//

import Foundation
public class NasiyaTab {
    private static let extra_tabs = NasiyaAppConfigurator.shared.isModule ? 1 : 0
    
    public static let home = extra_tabs + 0
    public static let installments = extra_tabs + 1
    public static let partners = extra_tabs + 2
    public static let profile = extra_tabs + 3
    
    public static func back(_ index: Int?) -> Bool {
        NasiyaAppConfigurator.shared.isModule && (index == 0)
    }
    
}
