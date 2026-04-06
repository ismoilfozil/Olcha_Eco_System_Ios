//
//  PayModulesConfiguration.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 19/04/23.
//


import OlchaUI
import UIKit
class PayModulesConfiguration {
    static let shared = PayModulesConfiguration()
    
    func setup() {
        UITableView.defaultBundle = .olchaPayModule
    }
}
