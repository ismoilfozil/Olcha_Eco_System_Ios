//
//  NasiyaDIContainer.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import Foundation
import Swinject
import OlchaUtils
import OlchaVerification
import UIKit
import OlchaAuth
extension String {
    static let olcha = "olcha"
}
public class OlchaDIContainer: DIResolver {
    
    public static let shared = OlchaDIContainer()
    
    public override init() {
        super.init()
        
        assembler.apply(assemblies: [
            ManagerAssembly(),
            ProfileAssembly(),
            HomeAssembly(),
            ReviewsAssembly(),
            ProductsListAssembly()
        ])
        
    }
}
